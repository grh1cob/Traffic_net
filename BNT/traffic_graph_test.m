%% Toy example using BNET to get dependencies on Road condition (bad, good) , Traffic density (bad,good) on traffic congestion (high,low)

% 
%%

%%
% *% *Author: Gourav Chatterjee
% 
% road condtion can be handled by a different BNET  where a. road width
% b.Pot-holes c. Encroachments etc can be a random variable
% (discrete/continuous)-> to be measured for training data to fill
% conditional Probabality distribution fucntion 
% 
% 
%  Traffic intenstiy is another random variable which is a continuous
%  random variable meas* * ured in every 1 hour or half an hour (considered
%  discrete here)*


function []= demo_BNET()
N=3;
dag=zeros(N,N);
T=1;R=2;C=3;  % T= traffic R= Road condition W=weather C= Congestion
dag(T,C)=1;dag(R,C)=1;
discrete_nodes = 1:N;
node_sizes = 2*ones(1,N); 
bnet = mk_bnet(dag, node_sizes, 'discrete', discrete_nodes);
draw_graph(bnet.dag);
%% conditional probablity distribution

bnet.CPD{T} = tabular_CPD(bnet, T, [0.75 0.25]);
bnet.CPD{R} = tabular_CPD(bnet, R, [0.5 0.5]);

%%  CPT for congestion 

CPT=zeros(2,2,2);   % T : 1->low traffic 2-> high traffic  R-> 1->bad road 2-> good road  
bnet.CPD{C} = tabular_CPD(bnet, C, 'CPT', [0.4 0.4 0.7 0.7 0.6 0.6 0.3 0.3]);  %  this comes from synthetic training data

%% inferecne engine 
engine = jtree_inf_engine(bnet);
engine

%% evidence based caluclation 

evidence=cell(1,N)
evidence{C} = 2;
[engine, loglik] = enter_evidence(engine, evidence);
marg_R = marginal_nodes(engine, R);
marg_R.T;
marg_T = marginal_nodes(engine, T);
marg_T.T;
sprintf('Probablity of bad road: %f ',marg_R.T(1))
sprintf('Probablity of bad traffic: %f ', marg_T.T(2))

end














