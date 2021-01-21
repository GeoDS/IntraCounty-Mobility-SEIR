% Scenario study 3: further reopen
load('Dane_result.mat')
load('data_0411_0814_2.mat','IR_true')

width = 1.8;
font = 15;
date = datetime(2020,4,11) + caldays(0:T);

region_title = ["Region 1", "Region 2", "Region 3", "Region 4", "Region 5", "Region 6", "Region 7", "Dane County Total"];


end_index = T-2;
T_predict = 10; 
IR_true_predict = IR_true(:,1:end_index+T_predict);


inflation_index_b = 1; % 2, or 3, factor multiplied to effective reproductive number
inflation_index_traffic = 1; % does not change traffic directly
figure_name = 'plots\case3_b3.jpg';
figure_name2 = 'plots\case3_daily_b3.jpg';


% Initialization
OU_d_b_predict = repmat(OU_d_b(:,end),1,Nsample);
OU_hat_b_predict = repmat(OU_hat_b(:,end),1,Nsample);
OU_sigma_b_predict = repmat(OU_sigma_b(:,end),1,Nsample);


S = S_total_sample(:,:,end_index);
E = E_total_sample(:,:,end_index);
I = I_total_sample(:,:,end_index);
R_I = R_I_total_sample(:,:,end_index);
b_end = b(:,:,end_index) * inflation_index_b;

Q =zeros(n_tracts,Nsample,1); % not used in final model, ignore it
S_predict = zeros(n_tracts,Nsample,24*T_predict+1);
E_predict = zeros(n_tracts,Nsample,24*T_predict+1);
I_predict = zeros(n_tracts,Nsample,24*T_predict+1);
R_I_predict = zeros(n_tracts,Nsample,24*T_predict+1);
b_predict = zeros(n_tracts,Nsample,24*T_predict+1);

S_predict(:,:,1) = S;
E_predict(:,:,1) = E;
I_predict(:,:,1) = I;
R_I_predict(:,:,1) = R_I;
b_predict(:,:,1) = b_end;

n_tr_predict = n_tr(:,:,end_index-6:end_index) * inflation_index_traffic;
n_tr_predict = repmat(n_tr_predict, 1, 1, ceil(T_predict/7));

% run the model forward
for i = 1:T_predict
    index_n_tr = mod(i,7);
    [S,E,I,~,R_I,b_end] ...
                    = SEIR_stochastic(S,E,I,Q,R_I,...
                    b_end,0,1,n_tr_predict(:,:,i),1,...
                        OU_d_b_predict,OU_hat_b_predict,OU_sigma_b_predict);
    S_predict(:,:,(1:24)+24*(i-1)+1) = S(:,:,2:end);
    E_predict(:,:,(1:24)+24*(i-1)+1) = E(:,:,2:end);
    I_predict(:,:,(1:24)+24*(i-1)+1) = I(:,:,2:end);
    R_I_predict(:,:,(1:24)+24*(i-1)+1) = R_I(:,:,2:end);
    b_predict(:,:,(1:24)+24*(i-1)+1) = b_end(:,:,2:end);
    
    S = S(:,:,end);
    E = E(:,:,end);
    I = I(:,:,end);
    R_I = R_I(:,:,end);
    b_end = b_end(:,:,end);
end
    
                    
                                                          
date_predict = date(end_index) + caldays(0:T_predict);
date_predict_hour = date(end_index) + hours(0:24*T_predict);

IRI_predict = I_predict + R_I_predict;
IRI_predict(8,:,:) = sum(IRI_predict(1:7,:,:));
IRI_predict_mean = mean(IRI_predict,2);
IRI_predict_mean = reshape(IRI_predict_mean,n_tracts+1,[]);

IRI_predict_50perc = prctile(IRI_predict,50,2);
IRI_predict_50perc = reshape(IRI_predict_50perc,n_tracts+1,[]);
IRI_predict_25perc = prctile(IRI_predict,25,2);
IRI_predict_25perc = reshape(IRI_predict_25perc,n_tracts+1,[]);
IRI_predict_75perc = prctile(IRI_predict,75,2);
IRI_predict_75perc = reshape(IRI_predict_75perc,n_tracts+1,[]);

IR_true_predict(8,:) = sum(IR_true_predict(1:7,:));

rmse = zeros(1,n_tracts);

plot_start_index = 110;

% complete prediction results of all regions
figure
set(gcf, 'Position',  [200, 200, 1500, 500])
for i = 1:n_tracts+1
    subplot(2,ceil(n_tracts/2),i)
    plot(date(plot_start_index)+caldays(0:end_index+T_predict-plot_start_index),IR_true_predict(i,plot_start_index:end),'LineWidth',width,'Color','b')
    hold on;
    
    plot(date_predict_hour,IRI_predict_50perc(i,:),'LineWidth',width,'Color',[201,35,35]/255)
    
    residual = IR_true_predict(i,end_index+1:end) - IRI_predict_50perc(i,25:24:241);
    rmse(1,i) = sqrt(mean(residual.^2));
    
    inBetween = [IRI_predict_25perc(i,:), fliplr(IRI_predict_75perc(i,:))];
    fill([date_predict_hour,flip(date_predict_hour)], inBetween, [201,35,35]/255, 'EdgeColor','none','facealpha',0.25);

    xline(date(end_index), 'LineWidth',width,'Color',[240,195,45]/255);

    ylabel('I+R')  
    title(region_title(i))
    set(gca,'Fontsize',20)
    if i == 5
        lgd = legend('true I+R','prediction median','prediction IQR','Location','northwest','Orientation','horizontal');
        lgd.FontSize = 16;
    end
end
% saveas(gcf,figure_name)










%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% predicted daily cases

IRI_predict_day_50perc = IRI_predict_50perc(:,1:24:241);
IRI_predict_day_25perc = IRI_predict_25perc(:,1:24:241);
IRI_predict_day_75perc = IRI_predict_75perc(:,1:24:241);

rmse_daily = zeros(1,n_tracts+1);

figure
set(gcf, 'Position',  [200, 200, 1500, 500])
for i = 1:n_tracts+1
    subplot(2,ceil(n_tracts/2),i)
    plot(date(end_index)+caldays(1:T_predict),IR_true_predict(i,end_index+1:end)-IR_true_predict(i,end_index:end-1),'LineWidth',width,'Color','b')
    hold on;
    
    plot(date(end_index)+caldays(1:T_predict),IRI_predict_day_50perc(i,2:end)-IRI_predict_day_50perc(i,1:end-1),'LineWidth',width,'Color',[201,35,35]/255)
    
    residual = (IR_true_predict(i,end_index+1:end)-IR_true_predict(i,end_index:end-1)) - (IRI_predict_day_50perc(i,2:end)-IRI_predict_day_50perc(i,1:end-1));
    rmse_daily(1,i) = sqrt(mean(residual.^2));
    
    inBetween = [IRI_predict_day_25perc(i,2:end)-IRI_predict_day_25perc(i,1:end-1), fliplr(IRI_predict_day_75perc(i,2:end)-IRI_predict_day_75perc(i,1:end-1))];
    fill([date(end_index)+caldays(1:T_predict),flip(date(end_index)+caldays(1:T_predict))], inBetween, [201,35,35]/255, 'EdgeColor','none','facealpha',0.25);

    ylabel('daily cases')  
    title(region_title(i))
    set(gca,'Fontsize',20)
    if i == 5
        lgd = legend('true daily cases','predicted daily cases','prediction IQR','Location','northwest','Orientation','horizontal');
        lgd.FontSize = 16;
    end
end
% saveas(gcf,figure_name2)
