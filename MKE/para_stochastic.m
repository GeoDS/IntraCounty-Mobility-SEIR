%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use an fixed point iteration to determine the coefficints in the
% stochastic equation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('data_0311_0812.mat')
% load total population N; traffic matrix n_tr; infections IR_true; popolation density; race ratio

% data of the last 7 days can be used as out of sample test
%%%%%%%%%%%%%%%%%%%
T = T - 7;
IR_true = IR_true(:,1:T+1);
n_tr = n_tr(:,:,1:T+1);
n_tr_diag = n_tr_diag(:,1:T+1);
%%%%%%%%%%%%%%%%%%%


n_tracts = size(N,1); % number of regions
Nsample = 2000; % number of samples


% initilization
d_b = 0.4;
OU_d_b = ones(n_tracts,1) * d_b;
OU_hat_b = ones(n_tracts,1) * 0.3;
OU_sigma_b = ones(n_tracts,1) * 0.15; 
b_initial = OU_hat_b;



i = 1; diff_b = 1;
tol = 5*10^-3; % tolerance

while (diff_b > tol) && i<50
    
    [b,~,~,~,~] = fun_EKI_stochastic(IR_true, N, n_tr, T, Nsample,pop_density,...
    OU_d_b(:,i), OU_hat_b(:,i), OU_sigma_b(:,i), b_initial);

    b_all = reshape(b, n_tracts, []);
    mu_b_eq = mean(b_all,2);    % mean of each row
    R_b_eq = var(b_all,0,2);    % variance of each row
    
    % update
    OU_d_b(:,i+1) = ones(n_tracts,1)*d_b;
    OU_hat_b(:,i+1) = mu_b_eq;
    OU_sigma_b(:,i+1) = realsqrt(2 * OU_d_b(:,i) .* R_b_eq);
    
    b_initial = mu_b_eq;
    
    diff_b = abs([OU_d_b(:,i+1)-OU_d_b(:,i), OU_hat_b(:,i+1)-OU_hat_b(:,i),OU_sigma_b(:,i+1)-OU_sigma_b(:,i)]);
    diff_b = max(diff_b,[],'all');
    i = i+1;
end

% resulting coefficients
b_initial = OU_hat_b(:,end);


[b,S_total_sample,E_total_sample,I_total_sample,...
    R_I_total_sample] = fun_EKI_stochastic(IR_true, N, n_tr, T, Nsample,pop_density,...
    OU_d_b(:,end), OU_hat_b(:,end), OU_sigma_b(:,end), b_initial);

% save('mke_result.mat')

