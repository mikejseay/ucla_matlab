fs = 44100;
freq1 = 500;
freq2 = 1000;
tone_len = 250;
silence_len = 500;
total_len = 1000;

time = 0:(1 / fs):(total_len / 1000);

tone1 = sin(2 * pi * freq1 * time);
tone2 = sin(2 * pi * freq2 * time);

figure; plot(tone1);
