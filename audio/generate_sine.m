function x = generate_sine(freq, fs, len)

time = (1 / fs):(1 / fs):(len / 1000);
x = sin(2 * pi * freq * time);

end