fs = 44100;
freq1 = 500;
freq2 = 1000;
tone_len = 250;
silence_len = 500;
total_len = 1000;

tone1 = generate_sine(freq1, fs, tone_len);
tone2 = generate_sine(freq2, fs, tone_len);
silence = generate_silence(fs, silence_len);

full_sound = [tone1, silence, tone2];

figure; plot(full_sound);
sound(full_sound, fs);
