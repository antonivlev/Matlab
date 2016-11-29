watch_data = load('Watch_Accel_17_11_16.txt', '-ascii');
labels = load('labels.txt', '-ascii');

makeWindowsArray(watch_data, labels);

function windowsArray = makeWindowsArray(data, labels)
    num_labels = size(labels, 1);
    windowsArray = zeros(1, num_labels);
    
    %for each label/window
    for i = 1:num_labels
        window = containers.Map();
        %matrices same size as data, filled with zeros, but have ones where start
        %and finish timestamps are
        start_sparse = data==labels(i, 1);
        finish_sparse = data==labels(i, 1);
        %Rows in data corresponding to label 
        [start_row, ~] = find(start_sparse);
        [finish_row, ~] = find(finish_sparse);
        
        window('mat') = data(start_row:finish_row, :); 
        windowsArray(1, i) = window;
    end
end


