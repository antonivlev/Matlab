clear;
D = load('Myo_Emg_17_11_16.txt', '-ascii'); disp('loaded all data');
D = abs(D);

window_size = 30;
b = (1/window_size)*ones(1, window_size);
a = 1;
dlmwrite('abs_emg.txt', D, 'delimiter', '\t', 'precision', 15); disp('wrote all data');

[~, num_cols] = size(D);

% x = D(1:5000, 3);
% t = D(1:5000, 9);
% y = filter(b, a, x);
% hold on
% plot(t(1:3:5000), x(1:3:5000));
% plot(t(1:3:5000), y(1:3:5000));


for i=1:num_cols-1
    filtered_arr = filter(b, a, D(:, i)); 
    fD(:, i) = filtered_arr(1:3:length(filtered_arr)); 
end

time_col = D(:, 9);
fD(:, 9) = time_col(1:3:length(time_col));

dlmwrite('filtered_emg.txt', fD, 'delimiter', '\t', 'precision', 15); disp('wrote filtered data');