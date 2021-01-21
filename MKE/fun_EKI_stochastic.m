function [b, S_total_sample,E_total_sample,I_total_sample,...
    R_I_total_sample] = ...
    fun_EKI_stochastic(IR_true, N, n_tr, T, Nsample, pop_density, ...
    OU_d_b, OU_hat_b, OU_sigma_b, b_initial)

n_tracts = size(N,1); % number of regions

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Initial distribution %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alpha_range = (pop_density - min(pop_density))/(max(pop_density)-min(pop_density))*30 + 60;
alpha_range = repmat(alpha_range, 1, Nsample);

sigma = 1;   % variance
rng('shuffle');

b = repmat(b_initial, 1, Nsample);  
b = cat(3,b,zeros(n_tracts,Nsample,T));

alpha = rand(n_tracts,Nsample);
alpha = alpha .* alpha_range;

beta = 0;  % finally not used, so set it to 0
gamma = 1; % transmission ratio b/w unreported and latent


OU_d_b = repmat(OU_d_b,1,Nsample);
OU_hat_b = repmat(OU_hat_b,1,Nsample);
OU_sigma_b = repmat(OU_sigma_b,1,Nsample);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%        Ensemble Kalman Filter      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S_total_sample = zeros(n_tracts,Nsample,T+1);
E_total_sample = zeros(n_tracts,Nsample,T+1);
I_total_sample = zeros(n_tracts,Nsample,T+1);
R_I_total_sample = zeros(n_tracts,Nsample,T+1);


% initial values
I = repmat(IR_true(:,1),1,Nsample);
E = alpha;
Q = zeros(size(E)); % number of qurantined, finally not used, ignore it
R_I = zeros(size(E));
S = N*ones(1,Nsample) - E - I;


S_total_sample(:,:,1) = S;
E_total_sample(:,:,1) = E;
I_total_sample(:,:,1) = I;
R_I_total_sample(:,:,1) = R_I;



for t = 1:T
        n_tr_day = reshape(n_tr(:,:,t), n_tracts, n_tracts);
        [S_total,E_total,I_total,~,R_I_total,b_total] ...
                            = SEIR_stochastic(S,E,I,Q,R_I,...
                            b(:,:,t),beta,1,n_tr_day,gamma,...
                            OU_d_b,OU_hat_b,OU_sigma_b); % run the model forward
        Se = S_total(:,:,end); Se = reshape(Se,n_tracts,Nsample);
        Ee = E_total(:,:,end); Ee = reshape(Ee,n_tracts,Nsample);
        Ie = I_total(:,:,end); Ie = reshape(Ie,n_tracts,Nsample);
        RIe = R_I_total(:,:,end); RIe = reshape(RIe,n_tracts,Nsample);
        be = b_total(:,:,end); be = reshape(be,n_tracts,Nsample);
        
        uE = [Se;Ee;Ie;RIe;be];
        uE_mean = mean(uE,2); uE_mean2 = uE_mean*ones(1,Nsample);
        
        MuE = Ie + RIe;
        MuE_mean = mean(MuE,2); MuE_mean2 = MuE_mean*ones(1,Nsample);
        
        % compute Cup and Cpp
        Cup = (uE-uE_mean2)*(MuE-MuE_mean2)'/Nsample;
        Cpp = (MuE-MuE_mean2)*(MuE-MuE_mean2)'/Nsample;
        
        d = IR_true(:,t+1);
        
        % update
        uA = uE + Cup*( (Cpp+sigma^2*eye(n_tracts))\(d*ones(1,Nsample) + sigma*randn(n_tracts,Nsample) - MuE) );
        S = uA(1:n_tracts,:); S(S<0) = 0; S = min(S,S_total_sample(:,:,t));
        E = uA(n_tracts+1:2*n_tracts,:); E(E<0) = 0;
        I = uA(2*n_tracts+1:3*n_tracts,:);      
        R_I = uA(3*n_tracts+1:4*n_tracts,:); R_I = max(R_I,R_I_total_sample(:,:,t));
        b(:,:,t+1) = uA(4*n_tracts+1:end,:); b(b<0) = 0;

        %%%%%%%%%%%%%%%%%%%%%%%
        %%% Quantities for plotting       
        S_total_sample(:,:,t+1) = S;
        E_total_sample(:,:,t+1) = E;
        I_total_sample(:,:,t+1) = I;
        R_I_total_sample(:,:,t+1) = R_I;

end
end