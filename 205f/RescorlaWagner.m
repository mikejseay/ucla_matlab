% blue traces are tone with puff trial
% red traces are light with puff trial
% black traces are tone + light with puff trial

CS_START_TIME = 1000;
CS_OFF_TIME = 2000;
US_START_TIME = 1900;
US_OFF_TIME = 2000;
CS1_INTENSITY = .4;
CS2_INTENSITY = .25;
CS5_INTENSITY = -.4;
US_INTENSITY = .5;
N_TRAINING_TRIALS = 10;
alpha = .01; %learning rate parameter

% demonstrates normal learning
% training_trials = ones(1, N_TRAINING_TRIALS);

% demonstrates overshadowing
% training_trials = ones(1, N_TRAINING_TRIALS) * 3;

% demonstrates blocking
training_trials = [ones(1, 100)];
% training_trials = [ones(1, N_TRAINING_TRIALS) * 4, ...
%     ones(1, N_TRAINING_TRIALS) * 3, ...
%     ones(1, N_TRAINING_TRIALS) * 5, ...
%     ones(1, N_TRAINING_TRIALS) * 1, ...
%     ones(1, N_TRAINING_TRIALS) * 2];

testing_trials = [1, 2, 3, 4, 5]; %testing phase will be a single type 1 trial


%%% ----------------- DESIGN THE EXPERIMENT --------------

trial_duration = 3000; % length of each trial (ms)
ttype_num = 5; % total number of different trial types
CS_num = 2; % total number of CSs
colorcode = 'brkgmc'; %color coding for up to 6 CSs

ttype = 1; %-----------------CS 1 only

CS_on(1, ttype) = CS_START_TIME; %start time in ms for CS #1 during trial type 1
CS_off(1, ttype) = CS_OFF_TIME; %end time in ms for CS #1 during trial type 1
CS_val(1, ttype) = CS1_INTENSITY; %intensity level (recommended 0-1) for CS #1 during trial type 1

CS_on(2, ttype) = CS_START_TIME; %start time in ms for CS #2 during trial type 1
CS_off(2, ttype) = CS_OFF_TIME; %end time in ms for CS #2 during trial type 1
CS_val(2, ttype) = 0; %intensity level (recommended 0-1) for CS #2 during trial type 1

US_on(ttype) = US_START_TIME; %start time for US during trial type 1
US_off(ttype) = US_OFF_TIME; %end time for US during trial type 1
US_val(ttype) = US_INTENSITY; %intensity level (recommended 0-1) for US during trial type 1

ttype = 2; %-----------------CS 2 only

CS_on(1, ttype) = CS_START_TIME; %start time in ms for CS #1 during trial type 2
CS_off(1, ttype) = CS_OFF_TIME; %end time in ms for CS #1 during trial type 2
CS_val(1, ttype) = 0; %intensity level (recommended 0-1) for CS #1 during trial type 2

CS_on(2, ttype) = CS_START_TIME; %start time in ms for CS #2 during trial type 2
CS_off(2, ttype) = CS_OFF_TIME; %end time in ms for CS #2 during trial type 2
CS_val(2, ttype) = CS2_INTENSITY; %intensity level (recommended 0-1) for CS #2 during trial type 2

US_on(ttype) = US_START_TIME; %start time for US during trial type 1
US_off(ttype) = US_OFF_TIME; %end time for US during trial type 1
US_val(ttype) = US_INTENSITY; %intensity level (recommended 0-1) for US during trial type 1

ttype = 3; %-----------------CS 1 + CS 2

CS_on(1, ttype) = CS_START_TIME; %start time in ms for CS #1 during trial type 2
CS_off(1, ttype) = CS_OFF_TIME; %end time in ms for CS #1 during trial type 2
CS_val(1, ttype) = CS1_INTENSITY; %intensity level (recommended 0-1) for CS #1 during trial type 2

CS_on(2, ttype) = CS_START_TIME; %start time in ms for CS #2 during trial type 2
CS_off(2, ttype) = CS_OFF_TIME; %end time in ms for CS #2 during trial type 2
CS_val(2, ttype) = CS2_INTENSITY; %intensity level (recommended 0-1) for CS #2 during trial type 2

US_on(ttype) = US_START_TIME; %start time for US during trial type 1
US_off(ttype) = US_OFF_TIME; %end time for US during trial type 1
US_val(ttype) = US_INTENSITY; %intensity level (recommended 0-1) for US during trial type 1

ttype = 4; %-----------------nothing

CS_on(1, ttype) = CS_START_TIME; %start time in ms for CS #1 during trial type 2
CS_off(1, ttype) = CS_OFF_TIME; %end time in ms for CS #1 during trial type 2
CS_val(1, ttype) = 0; %intensity level (recommended 0-1) for CS #1 during trial type 2

CS_on(2, ttype) = CS_START_TIME; %start time in ms for CS #2 during trial type 2
CS_off(2, ttype) = CS_OFF_TIME; %end time in ms for CS #2 during trial type 2
CS_val(2, ttype) = 0; %intensity level (recommended 0-1) for CS #2 during trial type 2

US_on(ttype) = US_START_TIME; %start time for US during trial type 1
US_off(ttype) = US_OFF_TIME; %end time for US during trial type 1
US_val(ttype) = US_INTENSITY; %intensity level (recommended 0-1) for US during trial type 1

ttype = 5; %-----------------CS 1 is negative

CS_on(1, ttype) = CS_START_TIME; %start time in ms for CS #1 during trial type 2
CS_off(1, ttype) = CS_OFF_TIME; %end time in ms for CS #1 during trial type 2
CS_val(1, ttype) = CS5_INTENSITY; %intensity level (recommended 0-1) for CS #1 during trial type 2

CS_on(2, ttype) = CS_START_TIME; %start time in ms for CS #2 during trial type 2
CS_off(2, ttype) = CS_OFF_TIME; %end time in ms for CS #2 during trial type 2
CS_val(2, ttype) = 0; %intensity level (recommended 0-1) for CS #2 during trial type 2

US_on(ttype) = US_START_TIME; %start time for US during trial type 1
US_off(ttype) = US_OFF_TIME; %end time for US during trial type 1
US_val(ttype) = US_INTENSITY; %intensity level (recommended 0-1) for US during trial type 1


%%% ------------ DESIGN THE LEARNING NETWORK -----------

CS_w(1) = 0; %initial value for weight on CS#1
CS_w(2) = 0; %initial value for weight on CS#2

%%%%%%%%%%%%%%%%%%%%%%%%%%%% BUILD & PLOT TRIAL TYPES %%%%%%%%%%%%%%%%%%%%%

figure(1); clf; %clear plotting window

clear start_w CR y CS_trace US_trace R; %clear trial structures prior to simulation

for ttype = 1:ttype_num %loop through trial types
    
    for t = 1:trial_duration %loop through time steps of the trial
        
        %set US value for this time step
        if t >= US_on(ttype) && t < US_off(ttype)
            US_trace(ttype, t) = US_val(ttype);
        else
            US_trace(ttype, t) = 0;
        end
        
        %set CS value for this time step
        for CS = 1:CS_num %loop through the CSs
            if t >= CS_on(CS, ttype) && t < CS_off(CS, ttype)
                CS_trace(CS, ttype, t) = CS_val(CS, ttype);
            else
                CS_trace(CS, ttype, t) = 0;
            end
        end
        
    end %end time loop
    
    % plot bottom traces... just show what the 3 trial types look like
    plot(squeeze(US_trace(ttype, :))+(CS_num + 1.5)*(ttype - 1)-ttype_num*(CS_num + 1.5), colorcode(ttype)); hold on;
    for CS = 1:CS_num %loop through the CSs
        plot(squeeze(CS_trace(CS, ttype, :))+(CS_num + 1.5)*(ttype - 1)+CS-ttype_num*(CS_num + 1.5), colorcode(ttype));
    end
    
    %    set(gca,'YTick',[],'YLim',[-.1 CS_num*ttype_num+1.1]);
    %    set(gca,'YLim',[-ttype_num*(CS_num+1.5)-.25 0]);
    
end %end trial type loop

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SIMULATE TRAINING TRIALS %%%%%%%%%%%%%%%%%%%%%%%%

for trial = 1:length(training_trials) %loop through training trials
    
    ttype = training_trials(trial); %set the type for the current trial
    
    %record the CS weight at the start of the trial
    for CS = 1:CS_num
        start_w(CS, trial) = CS_w(CS);
    end
    
    %loop through time steps of the trial
    for t = 1:trial_duration
        
        %-------------------- COMPUTE NEURAL ACTIVITY ------------------
        
        y(t) = 0; %initialize output to zero
        
        %compute summed prediction, y, over all CSs
        for CS = 1:CS_num
            
            %add weighted CS input to the output value
            % i.e. x1w1 + x2w2 + ... + xnwn
            y(t) = y(t) + CS_trace(CS, ttype, t) * CS_w(CS);
        end
        
        % total response is sum of prediction and US (?)
        R(t) = y(t) + US_trace(ttype, t);
        
        %----------------- ADJUST SYNAPTIC WEIGHTS -------------------
        
        % compute loss function AKA prediction error
        % as the US minus the prediction (weighted sum of CSs)
        L = US_trace(ttype, t) - y(t);
        %        L = US_trace(ttype,t);
        
        % don't let L be negative!
        if L < 0
            L = 0;
        end
        
        % adjust weights for each CS separately (for every time point)
        % delta w = alpha x prediction error x CS intensity at time point
        for CS = 1:CS_num
            CS_w(CS) = CS_w(CS) + alpha * CS_trace(CS, ttype, t) * L;
        end
        
        
    end %end time loop
    
    % plot the overall response (sum of CR and UR)
    plot(R + (trial - 1) * 1.5 + 1, colorcode(ttype)); %time plots of trial responses
    
    CR(trial) = sum(R(1:(US_on(ttype) - 1))); %trial plots of conditioned responses
    
end %end training trial loop

for trial = 1:length(testing_trials) %loop through training trials
    
    ttype = testing_trials(trial); %set the type for the current trial
    
    for t = 1:trial_duration %loop through time steps of the trial
        
        %-------------------- COMPUTE NEURAL ACTIVITY ------------------
        
        y(t) = 0; %initialize output to zero
        
        %set CS value for this time step
        for CS = 1:CS_num %loop through the CSs
            y(t) = y(t) + CS_trace(CS, ttype, t) * CS_w(CS); %add weighted CS input to the output value
        end
        
        %response is sum of prediction and US
        R(t) = y(t) + US_trace(ttype, t);
        
    end %end time loop
    
    plot(R+length(training_trials)*1.5+(trial - 1)*1.5+1, colorcode(ttype));
    
    CR = [CR, NaN, sum(R(1:(US_on(ttype) - 1)))];
    
end %end training trial loop

set(gca, 'YTick', []);

figure(2); clf;

subplot(2, 1, 1);
plot(CR, 'o-k'); set(gca, 'YTick', [], 'XLim', [0, length(CR) + 1]);
ylabel('Conditioned Response');

subplot(2, 1, 2); hold off;
for CS = 1:CS_num
    plot(start_w(CS, :), 'o-');
    hold on;
end
set(gca, 'YTick', [], 'XLim', [0, length(CR) + 1]);
ylabel('Weights');
legend('w1', 'w2', 'Location', 'northwest');