%IN THIS DOCUMENT LINES STARTING WITH A % SIGN ARE COMMENTS,
%THE OTHER LINES ARE LINES OF MATLAB CODE

%Minimal simulation of binary Hofield model with a single memory
%The key idea of a Hopfield model is that stable memories are formed
%in a reccurrent network by finding recurrent weights for which 
%the desired activity pattern (defined by a vector called "Memory")
%will produce itself--creating a stable point attractor, a memory.

%Octave (for those who do not have Matlab, and want to run the code)
%Instructions: http://wiki.octave.org/Octave_for_Windows
%Download: http://sourceforge.net/projects/octave/files/Octave%20Windows%20binaries/

rng(42);

numTimeSteps = 5;
% Memory = [0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1];
Memory = round(rand(1,40));
numNeurons = length(Memory);

%To make weight matrix transform 0 and 1 values into -1 and 1
%Then apply the formula W(i,j)=M(i)*M(j)
%These steps can be done in one line by multiplying the Memory 
%vector by it's own transpose (in Matlab the transpose of a veector V is V')
%to make the Weight Matrix.
%(2*X-1) is used to convert 0 to -1 and 1 to 1
WeightMatrix = (2*Memory-1)'*(2*Memory-1);
%Then zero all the diagonal (remove "autapses")
WeightMatrix(1:numNeurons+1:numNeurons*numNeurons)=0;

%Start with a random state
rng('shuffle');
State(1,:) = round(rand(1,numNeurons));

for t = 2:numTimeSteps
   
   CurrentState = WeightMatrix*State(t-1,:)';
   %Thresholding: threshold = 0;
   CurrentState(CurrentState>=0) =1;
   CurrentState(CurrentState<0)  =0;
   State(t,:)  = CurrentState;
   
end

imagesc(State);
