clear;
data = {
    'Watch_Accel_17_11_16.txt', ...
    'Myo_Accel_17_11_16.txt'
};
wmap = makeSlidingWindows(data, 5.3, 0);

vecs = [];
for i=1:length(wmap.keys)
	sensors = wmap(i);
	vecs = [vecs; sensors('Watch_Accel_17_11_16.txt')];
end
