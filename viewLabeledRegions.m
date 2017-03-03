function viewLabeledRegions()
%VIEWLABELEDREGIONS plots a region in the data specified by a label file.
%Data, labels and what to plot are specified inside script
	clear;
	watch_data = load('Data/Watch_Accel_17_11_16.txt', '-ascii');
	emg_gavin = load('Data/Myo_Emg_14_12_16.txt', '-ascii');
	labels = load('Data/labels.txt', '-ascii');

	watch_data = removeZeroTimes(watch_data);
	emg_gavin = removeZeroTimes(emg_gavin);

	windows_map = makeWindowsMap(watch_data, labels);
	w = windows_map(1);

	plot(emg_gavin(:, end), emg_gavin(:, 1));
end

function windows_map = makeWindowsMap(data, labels)
% MAKEWINDOWSMAP returns map of windows: {  1: {x:[...], y:[...], z:[...], t:[...], label: some_int},
%                                           ... ,
%                                           n:{...}  }
%
%   data - data matrix with rows like: x y z t
%   labels - window matrix with n rows like: start_t finish_t label

    num_labels = size(labels, 1);
    windows_map = containers.Map({1}, {containers.Map()});

    %for each label/window
    for i = 1:num_labels
        diff_mat_start = abs(data-labels(i, 1));
        diff_mat_finish = abs(data-labels(i, 2));
        [~, start_lin_ind] = min(diff_mat_start(:));
        [~, finish_lin_ind] = min(diff_mat_finish(:));

        %Rows in data corresponding to label
        [start_row, ~] = ind2sub(size(data), start_lin_ind);
        [finish_row, ~] = ind2sub(size(data), finish_lin_ind);
        w = containers.Map();
        w('label') = labels(i, 3);
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

function out = removeZeroTimes(mat)
    tcol = mat(:, end)~=0;
    out = mat(tcol, :);
end
