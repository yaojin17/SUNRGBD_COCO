function [annotate]=encode_coco_mask(mask, ii_idx, ann_id, classname, SUNRGBDMeta2DBB)
    annotate = struct('category_id', [], 'area', [], 'bbox', [], 'id', [], 'image_id', [], ...
        'mask_name', [], 'segmentation', [], 'iscrowd', false);
    
    annotate.area = sum(mask(:));
    if(annotate.area > 1)
        [y, x] = find(mask);
        tight_bbox = [min(x), min(y), max(x)-min(x), max(y)-min(y)];
        structArray = SUNRGBDMeta2DBB(ii_idx).groundtruth2DBB;
        matches = arrayfun(@(x) strcmp(x.classname, classname), structArray);
        matchingIndices = find(matches);
        if isempty(matchingIndices)
            annotate.bbox = tight_bbox;
        else
            iou_list = zeros(size(matchingIndices));
            for idx = 1:length(matchingIndices)
                metabbox = structArray(matchingIndices(idx)).gtBb2D;
                iou = computeIoU(tight_bbox, metabbox);
                iou_list(idx) = iou;
            end
            [max_iou, max_idx] = max(iou_list);
            if max_iou > 0.3
                annotate.bbox = structArray(matchingIndices(max_idx)).gtBb2D;
            else
                annotate.bbox = tight_bbox;
            end
        end
        if(annotate.bbox(3) > 0 && annotate.bbox(4) >0)
            annotate.image_id = ii_idx;
            annotate.mask_name = SUNRGBDMeta2DBB(ii_idx).sequenceName;
            annotate.segmentation =  MaskApi.encode(uint8(mask));
            annotate.id = ann_id;
            annotate.classname = classname;
        end
    end
end