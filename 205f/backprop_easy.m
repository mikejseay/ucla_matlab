clear;

tset = [...
0 1 1 0  0 0 1 0  0 1 1 1  0 1 1 0  1 0 0 1  1 1 1 1  1 1 1 1  1 1 1 1  1 1 1 1  1 1 1 1  ;
1 0 0 1  0 1 1 0  1 0 0 1  1 0 0 1  1 0 0 1  1 0 0 0  1 0 0 0  0 0 0 1  1 0 0 1  1 0 0 1  ;
1 0 0 1  0 0 1 0  0 0 1 0  0 0 1 0  1 1 1 1  1 1 1 1  1 1 1 1  0 0 0 1  1 1 1 1  1 1 1 1  ;
1 0 0 1  0 0 1 0  0 1 0 0  1 0 0 1  0 0 0 1  0 0 0 1  1 0 0 1  0 0 0 1  1 0 0 1  0 0 0 1  ;
0 1 1 0  0 1 1 1  1 1 1 1  0 1 1 0  0 0 0 1  1 1 1 1  1 1 1 1  0 0 0 1  1 1 1 1  1 1 1 1  ;

1 1 1 1  0 1 0 0  1 1 1 1  1 1 1 0  0 0 1 1  1 1 1 1  1 1 1 0  1 1 1 1  0 1 1 0  1 1 1 0  ;
1 0 0 1  1 1 0 0  0 0 0 1  0 0 0 1  0 1 0 1  1 0 0 0  1 0 0 0  0 0 0 1  1 0 0 1  1 0 1 0  ;
1 0 0 1  0 1 0 0  1 1 1 1  0 1 1 1  1 1 1 1  1 1 1 0  1 1 1 0  0 0 1 0  0 1 1 0  1 1 1 0  ;
1 0 0 1  0 1 0 0  1 0 0 0  0 0 0 1  0 0 0 1  0 0 0 1  1 0 1 0  0 1 0 0  1 0 0 1  0 0 1 0  ;
1 1 1 1  1 1 1 0  1 1 1 1  1 1 1 0  0 0 0 1  1 1 1 0  1 1 1 0  1 0 0 0  0 1 1 0  1 1 1 0  ;

0 0 0 0  0 0 1 0  0 1 1 1  0 1 1 1  1 0 1 0  1 1 1 0  0 1 1 1  1 1 1 0  0 1 1 0  0 1 1 1  ;
1 1 1 1  0 0 1 0  0 0 0 1  0 0 0 1  1 0 1 0  1 0 0 0  0 1 0 0  0 0 1 0  1 0 0 1  0 1 0 1  ;
1 0 0 1  0 0 1 0  0 1 1 1  0 0 1 1  1 1 1 0  1 1 1 0  0 1 1 1  0 0 1 0  1 1 1 1  0 1 1 1  ;
1 0 0 1  0 0 1 0  0 1 0 0  0 0 0 1  0 0 1 0  0 0 1 0  0 1 0 1  0 0 1 0  1 0 0 1  0 0 0 1  ;
1 1 1 1  0 0 1 0  0 1 1 1  0 1 1 1  0 0 1 0  1 1 1 0  0 1 1 1  0 0 1 0  0 1 1 0  0 1 1 1  ;

1 1 1 1  0 1 0 0  1 1 1 0  1 1 1 0  0 1 0 1  0 1 1 1  1 1 1 1  0 1 1 1  0 1 1 1  0 1 1 1  ;
1 0 0 1  0 1 0 0  0 0 1 0  0 0 1 0  0 1 0 1  0 1 0 0  1 0 0 0  0 0 0 1  0 1 0 1  1 0 0 1  ;
1 0 0 1  0 1 0 0  1 1 1 0  0 1 1 0  0 1 1 1  0 1 1 1  1 1 1 0  0 0 0 1  0 1 1 1  0 1 1 1  ;
1 0 0 1  0 1 0 0  1 0 0 0  0 0 1 0  0 0 0 1  0 0 0 1  1 0 0 1  0 0 0 1  0 1 0 1  0 0 0 1  ;
0 0 0 0  0 1 0 0  1 1 1 0  1 1 1 0  0 0 0 1  0 1 1 1  1 1 1 0  0 0 0 1  0 1 1 1  1 1 1 1  ];

maxdigit = 10; %train this many digits
maxexample = 4; %use this many examples per digit
npatterns = maxdigit * maxexample; % total patterns to train, also size of each "batch"

% DEFINE NETWORK DIMENSIONS
N = 20; %number of inputs (20 because each digit is a 4 * 5 pixel image)
L = 1; %number of hidden layers
K = [20]; %number of units per hidden layer, length must equal L
M = maxdigit; %number of output units

% to really utilize hidden layers, you should require the program to generate
% very similar ouputs to  very different inputs
% or very different outputs to very similar inputs

batch = 0; % 1=batch update; 0=online update
randorder = 0; % 1=randomize order of training set on each block, 0=constant order

alpha = .02; %learning rate

tgtval = 1; %train output neurons to generate this value upon jrecognizing their digit

maxblocks = 5000; %give up if convergence fails after this many training blocks
error_crit = .0001; %run this many training blocks

rnum = round(rand * 100000);
rng(rnum);
init_w_range = 1; %range scale factor for initial weight values

% INITIALIZE HIDDEN LAYERS
h(1).act = zeros(1, K(1)); %unit activations
h(1).out = zeros(1, K(1)); %unit outputs
h(1).dout = zeros(1, K(1)); %unit outputs
h(1).W = (1 - 2 * rand(N+1, K(1))) * init_w_range; %initial weights (add one input element for bias)
h(1).dW = h(1).W * 0; %initial weights (add one input element for bias)
h(1).W_log = zeros([size(h(1).W), maxblocks]);
for k = 2:L
    h(k).act = zeros(1, K(k)); %unit activations
    h(k).out = zeros(1, K(k)); %unit outputs
    h(k).dout = zeros(1, K(k)); %unit outputs
    h(k).W = (1 - 2 * rand(K(k-1)+1, K(k))) * init_w_range; %initial weights (add one input element for bias)
    h(k).dW = h(k).W * 0; %initial weights (add one input element for bias)
    h(k).W_log = zeros([size(h(k).W), maxblocks]);
end

% INITIALIZE OUTPUT LAYER
o.act = zeros(1, K(1)); %unit activations
o.out = zeros(1, K(1)); %unit outputs
o.dout = zeros(1, K(1)); %unit outputs
if L > 0
    o.W = (1 - 2 * rand(K(L)+1, M)) * init_w_range; %initial weights (add one input element for bias)
else
    o.W = (1 - 2 * rand(N+1, M)) * init_w_range; %weights
end
o.dW = o.W * 0;

O_pattern = zeros(maxexample, maxdigit, maxdigit);

%%build matrix for pattern order control
patnum = 0;
for q = 1:maxexample %loop through digits
    for p = 1:maxdigit %loop through examples
        patnum = patnum + 1;
        pattern_ID(patnum, 1:3) = [q, p, NaN];
    end
end

worst_error = Inf; %initialize worst error to infinity
block = 0; %initialize trial block counter

%for block = 1:maxblocks %loop through trial block
while (block < maxblocks) & (worst_error > error_crit) %loop through trial block
    
    block = block + 1; %increment trial block counter
    
    E(block) = 0; %initialize total error for the current trial block
    E_unit(block, 1:maxdigit) = 0; %initialize digit error for the current trial block
    
    patnum = 0; %initialize count of patterns presented in this block
    
    %randomize pattern order for this trial
    porder = pattern_ID;
    if ~batch & randorder
        porder(:, 3) = rand(npatterns, 1);
        porder = sortrows(porder, 3);
    end
    
    %%%%%%%%% INFERENCE STEP %%%%%%%%%%
    for q = 1:maxexample %loop through digits
        
        for p = 1:maxdigit %loop through examples
            
            patnum = patnum + 1; %increment count of patterns presented in this block
            
            %set target output vector
            tgt = zeros(1, M);
            tgt(porder(patnum, 2)) = tgtval;
            
            if ~batch %reset weight changes for each pattern if we are not averaging over the block
                o.dW = o.W * 0;
                for k = 1:L
                    h(k).dW = h(k).W * 0;
                end
            end
            
            %%%%%%%%%%%% FORWARD PROPAGATION OF ACTIVITY %%%%%%%%%%
            
            %input layer activity
            x = tset((q - 1)*5+[1:5], (porder(patnum, 2) - 1)*4+[1:4]); %copy training example to input units
            
            %first hidden layer activity
            if L > 0
                h(1).act = [x(:)', 1] * h(1).W; %compute unit activations for first hidden layer
                [h(1).out, h(1).dout] = logistic(h(1).act); %logistic activation function
                %h(1).out = ReLu(h(1).act); %linear activation function
            end
            
            %other hidden layer activities
            for k = 2:L
                h(k).act = [h(k-1).out, 1] * h(k).W; %compute unit activations for first hidden layer
                [h(k).out, h(k).dout] = logistic(h(k).act); %logistic activation function
                %h(k).out = ReLu(h(k).act); %linear activation function
            end
            
            %output layer activity
            if L > 0
                o.act = [h(L).out, 1] * o.W; %compute unit activations for first hidden layer
            else
                o.act = [x(:)', 1] * o.W; %compute unit activations for first hidden layer
            end
            [o.out, o.dout] = logistic(o.act); %logistic activation function
            
            %%%%%%%%%%%% BACKPROPAGATION OF ERROR %%%%%%%%%%
            
            %errors for output layer
            o.err = .5 * (o.out - tgt).^2; %quadratic error for each output unit
            o.delta = o.dout .* (o.out - tgt); %derivative of error with respect to the unit's summed input
            
            E(block) = E(block) + sum(o.err); %accumulate error over all patterns for this block
            E_unit(block, porder(patnum, 2)) = E_unit(block, porder(patnum, 2)) + sum(o.err) / maxexample; %accumulate error over all patterns for this block
            O_pattern(porder(patnum, 1), porder(patnum, 2), :) = o.out;
            
            if L > 0 %if there are hidden layers in the network
                
                %backpropagate error from output layer to last hidden layer
                h(L).delta = [h(L).dout, 0] .* (o.W * o.delta')';
                
                %backpropagate error through any remaining hidden layers
                for k = 1:(L - 1)
                    h(L-k).delta = [h(L-k).dout, 0] .* (h(L-k+1).W * h(L-k+1).delta(1:end-1)')';
                end
                
            end
            
            %%%%%%%%%%%% COMPUTE / ACCUMULATE WEIGHT CHANGES %%%%%%%%%
            if L > 0
                o.dW = o.dW - repmat([h(L).out, 1]', 1, M) .* repmat(o.delta, K(L)+1, 1);
                h(1).dW = h(1).dW - repmat([x(:)', 1]', 1, K(1)) .* repmat(h(1).delta(1:end-1), N+1, 1);
                for k = 2:L
                    h(k).dW = h(k).dW - repmat([h(k-1).out, 1]', 1, K(k)) .* repmat(h(k).delta(1:end-1), K(k-1)+1, 1);
                end
            else
                o.dW = o.dW - repmat([x(:)', 1]', 1, M) .* repmat(o.delta, N+1, 1);
            end
            
            %%%%%%%%%%%% UPDATE WEIGHTS %%%%%%%%%%
            
            if ~batch | patnum == npatterns %if updating online or at the last pattern of the batch
                
                %output weights
                o.W = o.W + alpha * o.dW;
                for k = 1:L
                    h(k).W_log(:, :, block) = h(k).W;
                    h(k).W = h(k).W + alpha * h(k).dW;
                end
                
            end
            
        end %digit loop
        
    end %example loop
    
    E(block) = E(block) / npatterns;
    worst_error = max(E_unit(block, :));
    mean_error = mean(E_unit(block, :));
    
end %block loop

% plot mean square error over training trials
figure(1); clf;
subplot(1+maxexample, 1, 1); hold on;
plot(E_unit(1:block, :));
for q = 1:maxexample
    subplot(1+maxexample, 1, q+1);
    imagesc(0:(M - 1), ...
        0:(M - 1), ...
        squeeze(O_pattern(q, :, :)));
    colorbar;
end

worst_error
mean_error
