function ac = spk_autocorr(spk, binsize, maxisi)

% spk = list of spike times in units of seconds
% binsize = width of each 

sh = 1;
minisi = 0;
isi = spk((1+sh):end) - spk(1:end-sh);
isihisto = histcounts(isi, 0:binsize:maxisi);

while minisi < maxisi
    sh = sh + 1;
    isi = spk((1+sh):end) - spk(1:end-sh);
    minisi = min(isi);
    isihisto = isihisto + histcounts(isi, 0:binsize:maxisi);
end

ac = [flip(isihisto), isihisto];

end