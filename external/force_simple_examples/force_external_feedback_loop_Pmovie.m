% FORCE.m
%
% This function generates the sum of 4 sine waves in figure 2D using the architecture of figure 1A with the RLS
% learning rule.
%
% written by David Sussillo

disp('Clearing workspace.');
clear;

linewidth = 3;
fontsize = 14;
fontweight = 'bold';

N = 1000;
p = 0.1;
g = 1.5;				% g greater than 1 leads to chaotic networks.
alpha = 1.0;
nsecs = 1440;
dt = 0.1;
learn_every = 2;

scale = 1.0/sqrt(p*N);
M = sprandn(N,N,p)*g*scale;
M = full(M);    % M is recurrent weight matrix

nRec2Out = N;
wo = zeros(nRec2Out,1); % output weights
dw = zeros(nRec2Out,1); % change in output weights
wf = 2.0*(rand(N,1)-0.5); % feedback weights

disp(['   N: ', num2str(N)]);
disp(['   g: ', num2str(g)]);
disp(['   p: ', num2str(p)]);
disp(['   nRec2Out: ', num2str(nRec2Out)]);
disp(['   alpha: ', num2str(alpha,3)]);
disp(['   nsecs: ', num2str(nsecs)]);
disp(['   learn_every: ', num2str(learn_every)]);


simtime = 0:dt:nsecs-dt;
simtime_len = length(simtime);
simtime2 = 1*nsecs:dt:2*nsecs-dt;

amp = 1.3;
freq = 1/60;
ft = (amp/1.0)*sin(1.0*pi*freq*simtime) + ...
     (amp/2.0)*sin(2.0*pi*freq*simtime) + ...
     (amp/6.0)*sin(3.0*pi*freq*simtime) + ...
     (amp/3.0)*sin(4.0*pi*freq*simtime);
ft = ft/1.5;

ft2 = (amp/1.0)*sin(1.0*pi*freq*simtime2) + ...
      (amp/2.0)*sin(2.0*pi*freq*simtime2) + ...
      (amp/6.0)*sin(3.0*pi*freq*simtime2) + ...
      (amp/3.0)*sin(4.0*pi*freq*simtime2);
ft2 = ft2/1.5;
% yes, these are exactly the same

wo_len = zeros(1,simtime_len);    
zt = zeros(1,simtime_len);
zpt = zeros(1,simtime_len);
x0 = 0.5*randn(N,1);
z0 = 0.5*randn(1,1);

x = x0; 
r = tanh(x); 
z = z0; 

do_film=true;

if do_film
    
    outfile='force_external_feedback_loop_P.avi';
    fps = 60;
    
    writerObj = VideoWriter(outfile);
    writerObj.FrameRate = fps;
    open(writerObj);

end

figure;
set(gcf, 'position', [0 120 1000 1000]);
ti = 0;
film_dum = 0;
P = (1.0/alpha)*eye(nRec2Out);
for t = simtime
    ti = ti + 1;
    
    % sim, so x(t) and r(t) are created.
    x = (1.0-dt)*x + M*(r*dt) + wf*(z*dt);
    % note here that x(t + dt) has three components,
    % 1.) the previous x(t);  simulates a leaky integrator (largest component)
    % 2.) recurrent inputs (small component)
    % 3.) feedback inputs from the output
    r = tanh(x);
    z = wo'*r;
    
    if mod(ti, learn_every) == 0
	% update inverse correlation matrix
	k = P*r;  % k gives the P-weighted firing rates
	rPr = r'*k; % rPr is the inner-product of the firing rates and the p-weighted version of themselves
	c = 1.0/(1.0 + rPr); % c is like a normalization constant (small)
    
    % take a picture
    film_dum = film_dum + 1;
    clf;
    P_vis = P;
    P_vis(logical(eye(nRec2Out))) = 0;
    imagesc_cb(P_vis);
    h = gcf;
    if do_film
        film(film_dum) = getframe(h);
        writeVideo(writerObj, film(film_dum));
    end
    
	P = P - k*(k'*c);
    
	% update the error for the linear readout
	e = z-ft(ti);
	
	% update the output weights
	dw = -e*k*c;	
	wo = wo + dw;
    end
    
    % Store the output of the system.
    zt(ti) = z;
    wo_len(ti) = sqrt(wo'*wo);	
end
error_avg = sum(abs(zt-ft))/simtime_len;
disp(['Training MAE: ' num2str(error_avg,3)]);    
disp(['Now testing... please wait.']);    

if do_film

    save(outfile,'film')
    close(writerObj);

    [a,w,p]=size(film(1).cdata);
    h2=figure;
    set(h2,'position',[80 120 w a]);
    axis off
    movie(h2, film, 1, fps)

end


% Now test. 
ti = 0;
for t = simtime				% don't want to subtract time in indices
    ti = ti+1;    
    
    % sim, so x(t) and r(t) are created.
    x = (1.0-dt)*x + M*(r*dt) + wf*(z*dt);
    r = tanh(x);
    z = wo'*r;
    
    zpt(ti) = z;
end
error_avg = sum(abs(zpt-ft2))/simtime_len;
disp(['Testing MAE: ' num2str(error_avg,3)]);


figure;
subplot 211;
plot(simtime, ft, 'linewidth', linewidth, 'color', 'green');
hold on;
plot(simtime, zt, 'linewidth', linewidth, 'color', 'red');
title('training', 'fontsize', fontsize, 'fontweight', fontweight);
xlabel('time', 'fontsize', fontsize, 'fontweight', fontweight);
hold on;
ylabel('f and z', 'fontsize', fontsize, 'fontweight', fontweight);
legend('f', 'z');


subplot 212;
hold on;
plot(simtime2, ft2, 'linewidth', linewidth, 'color', 'green'); 
axis tight;
plot(simtime2, zpt, 'linewidth', linewidth, 'color', 'red');
axis tight;
title('simulation', 'fontsize', fontsize, 'fontweight', fontweight);
xlabel('time', 'fontsize', fontsize, 'fontweight', fontweight);
ylabel('f and z', 'fontsize', fontsize, 'fontweight', fontweight);
legend('f', 'z');
	

