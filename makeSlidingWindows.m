function windows_map = makeSlidingWindows(data, win_size_t, overlap)
%MAKESLIDINGWINDOWS(data, win_size_t, overlap) divides data into windows
%	data - {"sensor0_data.txt", "sensor1_data.txt" ...}
% 		file format in listed files:
%						x0 	y0  z0 ... t0
%						x1 	y1	z1 ... t1
%						...
% 	win_size_t - size of window in seconds
% 	overlap - percentage of window overlap
%
%returns:
%	map {
%		1 (window_index): map {
%				"sensor0_data.txt":
%					matrix where columns are dimensions
%					rows are samples in window, like:
%					[
%						x0 y0 ... z0;
%						x1 y1 ... z1;
%						...
%					],
%				"sensor1_data.txt":[]
%				...
%			},
%      	... ,
%      	last_window: {...}
%	}
%
	%Initialise map to contain windows
	windows_map = containers.Map({1}, {containers.Map()});

	%for each data file
	for i=1:length(data)
		file_name = char(data(i));
		data_mat = load(strcat('Data/', file_name), '-ascii');

		fprintf('loaded: %s\n', file_name);
		data_mat = removeZeroTimes(data_mat);
		tvals = data_mat(:, end);

		%Timestamp of first window end
		t1 = min(tvals) + win_size_t*1000;
		fprintf('	t1: %d\n', t1);
		%Width of the window in points
		win_width = getPointsWindow(t1, tvals);
		fprintf('	window_width: %d points\n', win_width);

		start_p = 1;
		window_index = 1;
		%for each widow in current data file
		while start_p + win_width < length(tvals)
			window = data_mat 	(start_p : start_p+win_width-1, ...
								1 : end-1);
			start_p = start_p + (win_width-win_width*(overlap/100));

			if (i == 1)
				sensors_map = containers.Map();
				windows_map(window_index) = sensors_map;
			end
			smap = windows_map(window_index);
			smap(file_name) = window;

			window_index = window_index+1;
		end
		fprintf('	num_windows: %d\n', window_index);
	end
end

function ind = getPointsWindow(t, tcol)
	diff_tcol = tcol - t;
	diff_tcol = diff_tcol < 0;
	ind = length(find(diff_tcol));
end

function out = removeZeroTimes(mat)
%Removes rows where last col in mat is 0
    tcol = mat(:, end)~=0;
    out = mat(tcol, :);
end
