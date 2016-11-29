clear;
watch_data = load('Watch_Accel_17_11_16.txt', '-ascii');
labels = load('labels.txt', '-ascii');

windowsMap = makewindowsMap(watch_data, labels);
w = windowsMap(6);
plot(w('t'), w('x'), w('t'), w('y'));

function windowsMap = makewindowsMap(data, labels)
    num_labels = size(labels, 1);
    windowsMap = containers.Map({1}, {containers.Map()});
    
    %for each label/window
    for i = 1:num_labels
        window = containers.Map();
        %matrices same size as data, filled with zeros, but have ones where 
        %start and finish timestamps are
        start_sparse = data==labels(i, 1);
        finish_sparse = data==labels(i, 2);
        window('label') = labels(i, 3);
        
        %Rows in data corresponding to label 
        [start_row, ~] = find(start_sparse);
        [finish_row, ~] = find(finish_sparse);
                
        window('x') = data(start_row:finish_row, 1);
        window('y') = data(start_row:finish_row, 2);
        window('z') = data(start_row:finish_row, 3);
        window('t') = data(start_row:finish_row, 4);
        
        windowsMap(i) = window;
    end
end

function feat_vec = addFeatureVector(window)
    %for key in window.keys
end


