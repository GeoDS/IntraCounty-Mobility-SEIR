function [S_total,E_total,I_total,Q_total,R_I_total,b_total] ...
                            = SEIR_stochastic(S,E,I,Q,R_I,b,beta,T,n,gamma,...
                            OU_d_b,OU_hat_b,OU_sigma_b)
% this function runs the model forward
                        
n_tracts = size(n,1); Nsample = size(S,2);

% coefficients used in model
De = 5; 
Dc = 10;
Dl = 6;
cI = 0.1; 

dt = 1/24; N = T/dt;

n_out = sum(n)'; n_out_county = n_out*ones(1,Nsample);

S_total = zeros(n_tracts,Nsample,N+1); E_total = zeros(n_tracts,Nsample,N+1);
I_total = zeros(n_tracts,Nsample,N+1); 
Q_total = zeros(n_tracts,Nsample,N+1); 
R_I_total = zeros(n_tracts,Nsample,N+1); 
b_total = zeros(n_tracts,Nsample,N+1); 

S_total(:,:,1) = S; E_total(:,:,1) = E;
Q_total(:,:,1) = Q; 
I_total(:,:,1) = I; R_I_total(:,:,1) = R_I; 
b_total(:,:,1) = b; 


for step = 1:N
   
    P = S + E + R_I; P(P==0) = eps;       % P: free population     
    dIdt = E/De;
    
    S_n = S - dt * b.* (S - n_out_county.*(S./P) + n*(S./P)) .* ...
        (gamma*E - n_out_county.*(gamma*E./P) + n*(gamma*E./P)) ./ ...
        (P - n_out_county + n*ones(n_tracts, Nsample));
  
    E_n = E + dt * b.* (S - n_out_county.*(S./P) + n*(S./P)) .* ...
        (gamma*E - n_out_county.*(gamma*E./P) + n*(gamma*E./P)) ./ ...
        (P - n_out_county + n*ones(n_tracts, Nsample)) - dt*dIdt;
    
    I_n = I + dt * dIdt - cI*dt*I/Dc - (1-cI)*dt*I/Dl;
    
    R_I_n = R_I + cI*dt*I/Dc + (1-cI)*dt*I/Dl;
    
    Q_n = Q + dt* beta *dIdt; % Q is not used in the final model, ignore it
    
    b_n = b - OU_d_b .* (b - OU_hat_b) * dt + OU_sigma_b .* randn(n_tracts,Nsample)*sqrt(dt);
    
    
    l = find(S_n<0,n_tracts*Nsample);
    if ~isempty(l)
        S_n(l) = 0;
    end
    k = find(E_n<0,n_tracts*Nsample);
    if ~isempty(k)
        E_n(k) = 0;
    end
    o = find(b_n<0,n_tracts*Nsample);
    if ~isempty(o)
        b_n(o) = 0;
    end
     
    S = S_n; E = E_n; Q = Q_n; I = I_n; R_I = R_I_n; b = b_n;
    
    
    S_total(:,:,step+1) = S; E_total(:,:,step+1) = E; 
    Q_total(:,:,step+1) = Q; 
    I_total(:,:,step+1) = I; R_I_total(:,:,step+1) = R_I;
    b_total(:,:,step+1) = b;
end
end