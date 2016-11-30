clear;
watch_data = load('Watch_Accel_17_11_16.txt', '-ascii');
labels = load('labels.txt', '-ascii');

windows_map = makeWindowsMap(watch_data, labels);
w = windows_map(6);
%plot(w('t'), w('x'), w('t'), w('y'));
addFeatureVectors(windows_map);





function windows_map = makeWindowsMap(data, labels)
% MAKEWINDOWSMAP returns map of windows: {  1: {x:[...], y:[...], z:[...], t:[...], label: ...},  
%                                           ... , 
%                                           n:{...}  } 
%
%   data - data matrix with rows like: x y z t
%   labels - window matrix with n rows like: start_t finish_t label
    
    num_labels = size(labels, 1);
    windows_map = containers.Map({1}, {containers.Map()});
    
    %for each label/window
    for i = 1:num_labels
        w = containers.Map();
        %matrices same size as data, filled with zeros, but have ones where 
        %start and finish timestamps are
        start_sparse = data==labels(i, 1);
        finish_sparse = data==labels(i, 2);
        w('label') = labels(i, 3);
        
        %Rows in data corresponding to label 
        [start_row, ~] = find(start_sparse);
        [finish_row, ~] = find(finish_sparse);
                
        w('x') = data(start_row:finish_row, 1);
        w('y') = data(start_row:finish_row, 2);
        w('z') = data(start_row:finish_row, 3);
        w('t') = data(start_row:finish_row, 4);
        
        windows_map(i) = w;
    end
end

function feat_vec = addFeatureVector(window)
    data_mat = [window('x')';
                window('y')';
                window('z')';];
    
    sum_mat = data_mat * ones(numel(window('x')), 1);    
    av_mat = sum_mat./numel(window('x'));
    sq_diff_mat = ( data_mat - repmat(av_mat, 1, numel(window('x'))) ).^2;
    var_mat = ( sq_diff_mat * ones(numel(window('x')), 1) )./numel(window('x'));
    stnd_dev_mat = sqrt(var_mat);
    feat_vec = [av_mat' stnd_dev_mat'];
end

function addFeatureVectors(windows_map)
    for i = 1:numel(keys(windows_map))
        w = windows_map(i);
        w('feat_vec') = addFeatureVector(w);
    end
end
