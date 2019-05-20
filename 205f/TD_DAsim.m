% observations
% the magnitude of the US affects the magnitude of the prediction error (DA signal)
% the magnitude of the US also affects the magnitude of the acquired
    % CS prediction error (DA signal)
% the magnitude of the US does NOT affect the "learning rate"
% alpha affects the "learning rate"
% the density / width of the spectral timing units affects the learning rate
    % (and whether the prediction about the US is capable of migrating backward in time)

% figure 1
% blue traces are the dopamine prediction error signal
% subsequent trials go upwards
% single black trace is the US


%%% ----------------- DESIGN THE EXPERIMENT --------------


numtrials = 40;
every_nth = 1;  % give the US every nth trial

ttype_num = 1; % total number of different trial types

CS_num = 1; % total number of CSs

trial_duration = 3000; % length of each trial (ms)

CS_mag = 1;
CS_on_time = 1000;
CS_off_time = 2000;

US_mag = 2;
US_on_time = 1900;
US_off_time = 2000;

% start exponentially decaying neuron activation
% in spectral timing model  after this many milliseconds
trace_spacing = 25; 
trace_decay = 250;  % each spectral timing unit decays with this time constant
itime = 20;  % duration (ms) over which to average for the temporal difference computation

alpha = .001; %learning rate parameter
colorcode = 'brkgmc'; %color coding for up to 6 CSs
wfig = 2;

ttype = 1; %-----------------CS 1 only

CS_on(1, ttype) = CS_on_time; %start time in ms for CS #1 during trial type 1
CS_off(1, ttype) = CS_off_time; %end time in ms for CS #1 during trial type 1
CS_val(1, ttype) = CS_mag; %intensity level (recommended 0-1) for CS #1 during trial type 1

CS_on(2, ttype) = CS_on_time; %start time in ms for CS #2 during trial type 1
CS_off(2, ttype) = CS_off_time; %end time in ms for CS #2 during trial type 1
CS_val(2, ttype) = 0; %intensity level (recommended 0-1) for CS #2 during trial type 1

US_on(ttype) = US_on_time; %start time for US during trial type 1
US_off(ttype) = US_off_time; %end time for US during trial type 1
US_val(ttype) = US_mag; %intensity level (recommended 0-1) for US during trial type 1


training_trials = ones(1, numtrials); % 3 3 3 3 3 3 3 3 3 3]; %training phase wiil be 10 consecutive type 1 trials
%training_trials = [3 3 3 3 3 3 3 3 3 3]; %training phase wiil be 10 consecutive type 1 trials

testing_trials = [1]; %testing phase will be a single type 1 trial

%%% ------------ DESIGN THE LEARNING NETWORK -----------


%%%%%%%%%%%%%%%%%%%%%%%%%%%% BUILD & PLOT TRIAL TYPES %%%%%%%%%%%%%%%%%%%%%

figure(1); clf; %clear plotting window

clear V TDerror DA start_w CR y CS_trace US_trace R; %clear trial structures prior to simulation

for ttype = 1:ttype_num %loop through trial types
    
    for t = 1:trial_duration %loop through time steps of the trial
        
        %set US value for this time step
        if t >= US_on(ttype) & t < US_off(ttype)
            US_trace(ttype, t) = US_val(ttype);
        else
            US_trace(ttype, t) = 0;
        end
        
        %set CS value for this time step
        for CS = 1:CS_num %loop through the CSs
            
            if t < CS_on(CS, ttype)
                numtraces = 0;
            else
                numtraces = round(-.49999+(t - CS_on(CS, ttype))/trace_spacing) + 1;
            end
            
            for tr = 1:numtraces
                
                latency = (t - (CS_on(CS, ttype) + (tr - 1) * trace_spacing));
                
                % exponential decay for spectral timing unit activation
                CS_trace(CS, tr, ttype, t) = CS_val(CS, ttype) * exp(-latency/trace_decay);
                
            end
            
        end
        
    end %end time loop
    
    plot(squeeze(US_trace(ttype, :)), colorcode(ttype+2)); hold on;
    for CS = 1 %:CS_num %loop through the CSs
        for tr = 1:size(CS_trace, 2)
            plot(-3+squeeze(CS_trace(CS, tr, ttype, :))+CS*1.25, colorcode(ttype+2));
            CS_w(CS, tr) = -0.1; %initial value for weight on CS trace
        end
    end
    
    %    set(gca,'YTick',[],'YLim',[-.1 CS_num*ttype_num+1.1]);
    %    set(gca,'YLim',[-ttype_num*(CS_num+1.5)-.25 0]);
    
end %end trial type loop

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SIMULATE TRAINING TRIALS %%%%%%%%%%%%%%%%%%%%%%%%

tcount = 0;

for trial = 1:length(training_trials) %loop through training trials
    
    if tcount == 0
        giveUS = 1;
    else
        giveUS = 0;
    end
    
    tcount = tcount + 1;
    if tcount == every_nth
        tcount = 0;
    end
    
    ttype = training_trials(trial); %set the type for the current trial
    for CS = 1:CS_num %loop through the CSs
        for tr = 1:size(CS_trace, 2)
            start_w(CS, tr, trial) = CS_w(CS, tr); %record the CS weight at the start of the trial
        end
    end
    
    for t = 1:trial_duration %loop through time steps of the trial
        
        %-------------------- COMPUTE NEURAL ACTIVITY ------------------
        
        y(t) = 0; %initialize output to zero
        
        %compute summed prediction, y, over all CSs
        for CS = 1:CS_num %loop through the CSs
            for tr = 1:size(CS_trace, 2)
                y(t) = y(t) + CS_trace(CS, tr, ttype, t) * CS_w(CS, tr); %add weighted CS input to the output value
            end
        end
        
        %response is sum of prediction and US
        R(t) = y(t) + US_trace(ttype, t) * giveUS;
        
        %----------------- ADJUST SYNAPTIC WEIGHTS -------------------
        
        %compute loss function
        
        %        L = US_trace(ttype,t);
        %        if t>1
        %            L = (US_trace(ttype,t) + y(t) - y(t-1));
        %        end
        %        DA(t) = L;
        
        % the money shot
        if t > 2 * itime
            L = (giveUS * US_trace(ttype, t) + mean(y((t - itime + 1):t)) - mean(y((t - 2 * itime + 1):(t - itime))));
        else
            L = 0;
        end
        DA(t) = L;
        
        TDerror(trial, t) = L;
        V(trial, t) = y(t);
        
        %adjust weights
        for CS = 1:CS_num %loop through the CSs
            for tr = 1:size(CS_trace, 2)
                CS_w(CS, tr) = CS_w(CS, tr) + alpha * CS_trace(CS, tr, ttype, t) * L; %add weighted CS input to the output value
            end
        end
        
        
    end %end time loop
    
    plot(.1*DA+(trial - 1)*1.5+1, colorcode(ttype)); %time plots of trial responses
    
    CR(trial) = sum(R(1:(US_on(ttype) - 1))); %trial plots of conditioned responses
    
end %end training trial loop


% for trial = 1:length(testing_trials) %loop through training trials
%
%     ttype = testing_trials(trial); %set the type for the current trial
%
%     for t = 1:trial_duration %loop through time steps of the trial
%
%         %-------------------- COMPUTE NEURAL ACTIVITY ------------------
%
%         y(t) = 0; %initialize output to zero
%
%         %set CS value for this time step
%         for CS=1:CS_num %loop through the CSs
%             y(t) = y(t) + CS_trace(CS,ttype,t) * CS_w(CS); %add weighted CS input to the output value
%         end
%
%         %response is sum of prediction and US
%         R(t) = y(t) + US_trace(ttype,t);
%
%     end %end time loop
%
%     %plot(R+length(training_trials)*1.5+(trial-1)*1.5+1,colorcode(ttype));
%     plot(DA+length(training_trials)*1.5+(trial-1)*1.5+1,colorcode(ttype));
%
%     CR = [CR NaN sum(R(1:(US_on(ttype)-1)))];
%
% end %end training trial loop
%
% set(gca,'YTick',[]);

figure(wfig); clf;

subplot(1, 4, 1);
plot(CR/1000, 'o-k'); set(gca, 'XLim', [0, length(CR) + 1]);
ylabel('Licking');

subplot(1, 4, 2); hold off;
for CS = 1 %:CS_num
    imagesc(squeeze(start_w(1, :, :))');
    hold on;
end
%set(gca,'YTick',[],'YTick',[]);
ylabel('weights');

subplot(1, 4, 3); hold off;
for CS = 1 %:CS_num
    imagesc(TDerror);
    hold on;
end
ylabel('DA');
%set(gca,'YTick',[],'YTick',[]);
%colorbar;

subplot(1, 4, 4); hold off;
for CS = 1 %:CS_num
    imagesc(V);
    hold on;
end
ylabel('V');
%set(gca,'YTick',[],'YTick',[]);
%colorbar;

