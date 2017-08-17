
do_film=true;

if do_film

writerObj = VideoWriter('ern_cohlinetopowithERP_theta_nki_0001.avi');
writerObj.FrameRate = 4;
open(writerObj);

outfile='ern_cohlinetopowithERP_theta_nki_0001.mat';

end


%%

film_dum=0;

for timeframe=t_start:spacefactor:t_end
    figure;
    set(gcf,'position',[0 120 1280 800]);
    film_dum=film_dum+1;
    
    h=gcf;
    if do_film
        
        film(film_dum)=getframe(h);
        writeVideo(writerObj,film(film_dum));
        
    end
    close(h);
end
%end


%%

if do_film

save(outfile,'film')
close(writerObj);

%%

[a,w,p]=size(film(1).cdata);
h2=figure;
set(h2,'position',[80 120 w a]);
axis off
movie(h2,film,3,3)

end
