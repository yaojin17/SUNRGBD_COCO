function iou = computeIoU(box1, box2)
    % Compute Intersection over Union (IoU) for two bounding boxes
    % Each bounding box is in the format [x, y, width, height]

    % Convert boxes to [x_min, y_min, x_max, y_max] format
    box1_x_max = box1(1) + box1(3);
    box1_y_max = box1(2) + box1(4);
    box2_x_max = box2(1) + box2(3);
    box2_y_max = box2(2) + box2(4);

    % Compute intersection
    x_min_inter = max(box1(1), box2(1));
    y_min_inter = max(box1(2), box2(2));
    x_max_inter = min(box1_x_max, box2_x_max);
    y_max_inter = min(box1_y_max, box2_y_max);

    width_inter = max(0, x_max_inter - x_min_inter);
    height_inter = max(0, y_max_inter - y_min_inter);
    area_inter = width_inter * height_inter;

    % Compute the area of each bounding box
    area_box1 = box1(3) * box1(4);
    area_box2 = box2(3) * box2(4);

    % Compute the union
    area_union = area_box1 + area_box2 - area_inter;

    % Compute IoU
    iou = area_inter / area_union;
end

