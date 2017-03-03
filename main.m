clear;
global d;
d = [1 2 3];
data = {
    'Watch_Accel_17_11_16.txt', ...
    'Myo_Emg_14_12_16.txt'
};
makeSlidingWindows(data, 2, 20);
