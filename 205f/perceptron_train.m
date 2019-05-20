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
1 1 1 1  0 0 1 0  0 1 1 1  0 1 1 1  0 0 1 0  1 1 1 0  0 1 1 1  0 0 1 0  0 1 1 0  0 1 1 1  ];

% allows empty nodes to have inhibitory effect
tset(tset == 0) = - 1;

maxdigit = 10;   % train this many distinct digits
maxexample = 3; % use this many examples per digit

maxweight = 1;  % largest permitted absolute weight value
alpha = .0001;  % learning rate
tgtval = 1.1;   % train output neurons to generate this value upon recognizing their digit
                % analogous to US intensity

% use initial weights?
%load initial_weights2;

initial_weights = 1 - rand(4, 5, maxdigit) * 2; % initial weights to random values between -1 and 1

W = initial_weights;

nblocks = 5000; % run this many training blocks
                % here we used a fixed number, but we could check error periodically and stop at a criterion

digit_error = zeros(nblocks, maxdigit);
digit_output = zeros(maxdigit, maxdigit);

one_error = zeros(nblocks, 2);
one_output = zeros(nblocks, 2);

W_log = zeros([size(W) nblocks]);

for block = 1:nblocks % loop through trial block
    
    for outnode = 1:maxdigit % output to train (i.e. classifier node for each digit)
        
        digit_error(block, outnode) = 0;
        
        %%%%%%%%% INFERENCE STEP %%%%%%%%%%
        for d = 1:maxdigit %loop through digits
            
            % if the output node we are training matches the current digit,
            % our target should be 1, else 0
            if d == outnode
                tgt = 1;
            else
                tgt = 0;
            end
            
            digit_output(d, outnode) = 0;
            
            for i = 1:maxexample %loop through examples
                E = 0; %initialize error to zero
                y = 0; %initialize output to zero
                for r = 1:5 %loop through pixel rows
                    for c = 1:4 %loop through pixel columns
                        
                        % copy the current digit image to x
                        x(c, r) = tset((i - 1)*5+r, (d - 1)*4+c);
                        
                        % IMPORTANT
                        % here we are computing the "output" value (scalar)
                        % for the current digit
                        y = y + x(c, r) * W(c, r, outnode);
                    end
                end
%                 y = y + bias_W(outnode);
                E = E + .5 * (tgt * tgtval - y)^2;
                digit_output(d, outnode) = digit_output(d, outnode) + y / maxexample;
            end
            
            one_error(block, tgt+1) = one_error(block, tgt+1) + E;
            one_output(block, tgt+1) = one_output(block, tgt+1) + y;
            
        end
        
        %%%%%% TRAINING STEP %%%%%%
        for d = 1:maxdigit %loop through digits
            for i = 1:3 %loop through examples
                for r = 1:5 %loop through pixel rows
                    for c = 1:4 %loop through pixel columns
                        W(c, r, outnode) = W(c, r, outnode) - alpha * E * x(c, r);
%                         W(c, r, outnode) = W(c, r, outnode) + alpha * y * x(c, r);
                        if W(c, r, outnode) > maxweight
                            W(c, r, outnode) = maxweight;
                        elseif W(c, r, outnode) < - maxweight
                            W(c, r, outnode) = - maxweight;
                        end
                    end
                end
            end
        end
        
        digit_error(block, outnode) = digit_error(block, outnode) + E;
        
    end
    
    W_log(:, :, :, block) = W;
    
end


figure(1); clf;
for d = 1:maxdigit
    subplot(2, 5, d); imagesc(squeeze(W(:, :, d))'); colorbar;
end

figure(2); clf; hold on;
subplot(1, 2, 1); hold on;
for d = 1:maxdigit
    plot(digit_error(:, d));
end
title('ERROR');

subplot(1, 2, 2); hold on;
plot(one_output(:, 1)/27);
plot(one_output(:, 2)/3);
title('OUTPUT');