

function []=hmm_traffic()

disp('hidden markov model running..')
%%

%  congestion level :  congested, mid_congested & free

%  Travel time : high,mid and low

%% initial transition and emission probablity

 trans=[0.8 0.1 0.1;0.1 0.8 0.1;0.1 0.1 0.8];
 emis = [0.7 0.2 0.1;  % travel time-> high medium low
    0.2 0.5 0.3; 0.2 0.3 0.5]; 

%% generationeneration using Synthetic Training data of 2500 timesteps
congested=3*ones(300,1);med_congested=2*ones(300,1);free=ones(300,1);
states =[congested;congested;med_congested;free;med_congested;med_congested;free;free;med_congested;congested;congested;congested;med_congested;med_congested;free];
low=ones(300,1);
med=2*ones(300,1);
high=3*ones(300,1);

%%  Sequence geeneration for travel time in a busy road with importance sampling 
seq=[high;high;high;med;med;med;med;low;med;med;high;high;med;med;low];

%% training the hmm using seq  (uses MATLAB function on statistics and machine learning toolbox) 

[estTR,estE]=hmmtrain(seq,trans,emis,'maxiterations',100);
[T E]=hmmestimate(seq,states);

%% get the states path forn unknown sequence of travel time  (should be done online) 
seq1=[low;med;high;med;med;high;high;high;high;med;low;low;low];

%%  Inference enegine to undertand status of hidden variables

[STATES_estimate,logprob] = hmmviterbi(seq1,T,E);
plot(STATES_estimate);
legend('State estimate');
logprob; 
hold on ;
end




