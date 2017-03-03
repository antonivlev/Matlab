function output_map = makeSlidingWindows(data, win_size_t, overlap)
%MAKESLIDINGWINDOWS(data, win_size_t, overlap) divides data into windows
%	data - {"sensor0_data.txt", "sensor1_data.txt" ...}
% 		file format: 	x0 	y0  z0 ... t0
%						x1 	y1	z1 ... t1
%						...
% 	win_size_t - size of window in seconds
% 	overlap - percentage of window overlap
%
%returns:
%	cell arr {
%		1: map {
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
%      	last_window: {}
%	}
%sensor vals are in the same order as filenames in data
%
windows_map = containers.Map({1}, {containers.Map()});

for i=1:length(data)
	file_name = char(data(i));
	data_mat = load(strcat('Data/', file_name), '-ascii');
	disp(strcat('loaded ', file_name));
	data_mat = removeZeroTimes(data_mat);
	tvals = data_mat(:, end);
	%Timestamp of first window end
	t1 = min(tvals) + win_size_t*1000;
	disp(strcat('----t1:', string(t1)));
	%Width of the window in points
	win_width = getPointsWindow(t1, tvals);
	disp(strcat('---- width:', string(win_width), ' points'));
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
