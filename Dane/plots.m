% load('Dane_result.mat')
width = 1.8;
width2 = 1.2;
font = 15;

date = datetime(2020,4,11) + caldays(0:T);
date_label = datestr(date,'mm/dd');
box_labels = repmat("",length(date),1);
for i = 1:length(date)
    if mod(i,5) == 1
        box_labels(i) = convertCharsToStrings(date_label(i,:));
    end
end

Nsample = size(b,2);



% Compute the mean and quantiles of the results
b_mean = mean(b,2); b_mean = reshape(b_mean,n_tracts,T+1);
S_mean = mean(S_total_sample,2); S_mean = reshape(S_mean,n_tracts,[]);

N_all = repmat(N,1,Nsample, T+1);
n_tr_diag_all = reshape(n_tr_diag,n_tracts,1,[]);
n_tr_diag_all = repmat(n_tr_diag_all, 1, Nsample,1);

Re = b / 0.16 .* S_total_sample ./ N_all;
Re_traffic = b / 0.16 .* S_total_sample ./ N_all ./ n_tr_diag_all;
Re_mean = mean(Re,2); Re_mean = reshape(Re_mean,n_tracts,T+1);
Re_traffic_mean = mean(Re_traffic,2); Re_traffic_mean = reshape(Re_traffic_mean,n_tracts,T+1);


b_25perc = prctile(b,25,2); b_25perc = reshape(b_25perc,n_tracts,T+1);
b_75perc = prctile(b,75,2); b_75perc = reshape(b_75perc,n_tracts,T+1);
Re_25perc = prctile(Re,25,2); Re_25perc = reshape(Re_25perc,n_tracts,T+1);
Re_75perc = prctile(Re,75,2); Re_75perc = reshape(Re_75perc,n_tracts,T+1);
Re_traffic_25perc = prctile(Re_traffic,25,2); Re_traffic_25perc = reshape(Re_traffic_25perc,n_tracts,T+1);
Re_traffic_75perc = prctile(Re_traffic,75,2); Re_traffic_75perc = reshape(Re_traffic_75perc,n_tracts,T+1);

b_3average = zeros(n_tracts,T+1);
b_25perc_3average = zeros(n_tracts,T+1);
b_75perc_3average = zeros(n_tracts,T+1);
Re_3average = zeros(n_tracts,T+1);
Re_25perc_3average = zeros(n_tracts,T+1);
Re_75perc_3average = zeros(n_tracts,T+1);
Re_traffic_3average = zeros(n_tracts,T+1);
Re_traffic_25perc_3average = zeros(n_tracts,T+1);
Re_traffic_75perc_3average = zeros(n_tracts,T+1);

for i = 1:T+1
    if i < 3
        b_3average(:,i) = sum(b_mean(:,1:i),2)/i;
        b_25perc_3average(:,i) = sum(b_25perc(:,1:i),2)/i;
        b_75perc_3average(:,i) = sum(b_75perc(:,1:i),2)/i;
        Re_3average(:,i) = sum(Re_mean(:,1:i),2)/i;
        Re_25perc_3average(:,i) = sum(Re_25perc(:,1:i),2)/i;
        Re_75perc_3average(:,i) = sum(Re_75perc(:,1:i),2)/i;
        Re_traffic_3average(:,i) = sum(Re_traffic_mean(:,1:i),2)/i;
        Re_traffic_25perc_3average(:,i) = sum(Re_traffic_25perc(:,1:i),2)/i;
        Re_traffic_75perc_3average(:,i) = sum(Re_traffic_75perc(:,1:i),2)/i;
    else
        b_3average(:,i) = sum(b_mean(:,i-2:i),2)/3;
        b_25perc_3average(:,i) = sum(b_25perc(:,i-2:i),2)/3;
        b_75perc_3average(:,i) = sum(b_75perc(:,i-2:i),2)/3;
        Re_3average(:,i) = sum(Re_mean(:,i-2:i),2)/3;
        Re_25perc_3average(:,i) = sum(Re_25perc(:,i-2:i),2)/3;
        Re_75perc_3average(:,i) = sum(Re_75perc(:,i-2:i),2)/3;
        Re_traffic_3average(:,i) = sum(Re_traffic_mean(:,i-2:i),2)/3;
        Re_traffic_25perc_3average(:,i) = sum(Re_traffic_25perc(:,i-2:i),2)/3;
        Re_traffic_75perc_3average(:,i) = sum(Re_traffic_75perc(:,i-2:i),2)/3;
    end
end


b_7average = zeros(n_tracts,T+1);
b_25perc_7average = zeros(n_tracts,T+1);
b_75perc_7average = zeros(n_tracts,T+1);
Re_7average = zeros(n_tracts,T+1);
Re_25perc_7average = zeros(n_tracts,T+1);
Re_75perc_7average = zeros(n_tracts,T+1);
Re_traffic_7average = zeros(n_tracts,T+1);
Re_traffic_25perc_7average = zeros(n_tracts,T+1);
Re_traffic_75perc_7average = zeros(n_tracts,T+1);

for i = 1:T+1
    if i < 7
        b_7average(:,i) = sum(b_mean(:,1:i),2)/i;
        b_25perc_7average(:,i) = sum(b_25perc(:,1:i),2)/i;
        b_75perc_7average(:,i) = sum(b_75perc(:,1:i),2)/i;
        Re_7average(:,i) = sum(Re_mean(:,1:i),2)/i;
        Re_25perc_7average(:,i) = sum(Re_25perc(:,1:i),2)/i;
        Re_75perc_7average(:,i) = sum(Re_75perc(:,1:i),2)/i;
        Re_traffic_7average(:,i) = sum(Re_traffic_mean(:,1:i),2)/i;
    else
        b_7average(:,i) = sum(b_mean(:,i-6:i),2)/7;
        b_25perc_7average(:,i) = sum(b_25perc(:,i-6:i),2)/7;
        b_75perc_7average(:,i) = sum(b_75perc(:,i-6:i),2)/7;
        Re_7average(:,i) = sum(Re_mean(:,i-6:i),2)/7;
        Re_25perc_7average(:,i) = sum(Re_25perc(:,i-6:i),2)/7;
        Re_75perc_7average(:,i) = sum(Re_75perc(:,i-6:i),2)/7;
        Re_traffic_7average(:,i) = sum(Re_traffic_mean(:,i-6:i),2)/7;
        Re_traffic_25perc_7average(:,i) = sum(Re_traffic_25perc(:,i-6:i),2)/7;
        Re_traffic_75perc_7average(:,i) = sum(Re_traffic_75perc(:,i-6:i),2)/7;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plot of the transmission rate
figure
set(gcf, 'Position',  [200, 200, 1500, 550])
for i = 1:n_tracts
    b_plot = b(i,:,:);
    b_plot = reshape(b_plot, Nsample, []);
    subplot(2,ceil(n_tracts/2),i)
    boxplot(b_plot,'symbol','','Labels',box_labels,'LabelOrientation','inline')
    ylim([0,1])
    ylabel('b')
    title('Transmission rate')
    set(gca,'Fontsize',font)
end
% saveas(gcf,'plots\b_rate.jpg')



% plot of cumulative infections
figure
set(gcf, 'Position',  [200, 200, 1100, 500])
for i = 1:n_tracts
    subplot(2,ceil(n_tracts/2),i)
    plot(date,IR_true(i,:),'LineWidth',width)
    hold on;
    I_plot = reshape(I_total_sample(i,:,:), Nsample, []);
    R_I_plot = reshape(R_I_total_sample(i,:,:), Nsample, []);
    plot(date,mean(I_plot)+mean(R_I_plot),'LineWidth',2.1)
    ylabel('I+R')  
    title('Cumulative Infections')
    legend('true I+R', 'model I+R','Location','northwest')
    set(gca,'Fontsize',font)
end
% saveas(gcf,'plots\IR.jpg')


% plot of S, E, I, and R
figure
set(gcf, 'Position',  [200, 200, 1400, 720])
for i = 1:n_tracts
    subplot(4,n_tracts,0*n_tracts+i)
    S_plot = reshape(S_total_sample(i,:,:), Nsample, []);
    plot(date,mean(S_plot),'LineWidth',width)
    ylabel('S') 
    title({'Susceptibles',''})
    set(gca,'Fontsize',font)
    
    
    subplot(4,n_tracts,1*n_tracts+i)
    E_plot = reshape(E_total_sample(i,:,:), Nsample, []);
    plot(date,mean(E_plot),'LineWidth',width)
    ylabel('E') 
    title('Latent')
    set(gca,'Fontsize',font)
    
    subplot(4,n_tracts,2*n_tracts+i)
    I_plot = reshape(I_total_sample(i,:,:), Nsample, []);
    plot(date,mean(I_plot),'LineWidth',width)
    ylabel('I') 
    title('Infections')
    set(gca,'Fontsize',font)
    
    
    subplot(4,n_tracts,3*n_tracts+i)
    R_I_plot = reshape(R_I_total_sample(i,:,:), Nsample, []);
    plot(date,mean(R_I_plot),'LineWidth',width)
    ylabel('R') 
    title('Removed cases')
    set(gca,'Fontsize',font)
end
% saveas(gcf,'plots\SEIR.jpg')



% 3-day average Re divided by inner region traffic
figure
set(gcf, 'Position',  [100, 100, 900, 300])
for km = 1:n_tracts-1
    plot(date,Re_traffic_3average(km,:),'LineWidth',width)
    hold on;
end
plot(date,Re_traffic_3average(7,:),'LineWidth',width,'Color',[145,10,10]/255)
inBetween = [Re_traffic_25perc_3average(7,:), fliplr(Re_traffic_75perc_3average(7,:))];
fill([date,flip(date)], inBetween, [145,10,10]/255, 'EdgeColor','none','facealpha',0.25);

xline(datetime(2020,5,26),'--', 'LineWidth',width,'Color',[247,217,21]/255);
xline(datetime(2020,6,15),'--', 'LineWidth',width,'Color',[21,247,179]/255);
xline(datetime(2020,7,2),'--', 'LineWidth',width,'Color',[21,202,247]/255);
xline(datetime(2020,7,13),'--', 'LineWidth',width,'Color',[185,107,238]/255);

title({'3 day average R_e / inner region traffic'})
set(gca,'Fontsize',24)
lgd = legend('region 1','region 2','region 3','region 4','region 5','region 6','region 7','region 7 IQR');
lgd.FontSize = 20;
hold off
% saveas(gcf,'plots\b_traffic_3average.jpg')





% 7-day average Re divided by inner region traffic
figure
set(gcf, 'Position',  [100, 100, 900, 300])
for km = 1:n_tracts-1
    plot(date,Re_traffic_7average(km,:),'LineWidth',width)
    hold on;
end
plot(date,Re_traffic_7average(7,:),'LineWidth',width,'Color',[145,10,10]/255)
inBetween = [Re_traffic_25perc_7average(7,:), fliplr(Re_traffic_75perc_7average(7,:))];
fill([date,flip(date)], inBetween, [145,10,10]/255, 'EdgeColor','none','facealpha',0.25);

xline(datetime(2020,5,26),'--', 'LineWidth',width,'Color',[247,217,21]/255);
xline(datetime(2020,6,15),'--', 'LineWidth',width,'Color',[21,247,179]/255);
xline(datetime(2020,7,2),'--', 'LineWidth',width,'Color',[21,202,247]/255);
xline(datetime(2020,7,13),'--', 'LineWidth',width,'Color',[185,107,238]/255);

title({'7 day average R_e / inner region traffic'})
set(gca,'Fontsize',24)
lgd = legend('region 1','region 2','region 3','region 4','region 5','region 6','region 7','region 7 IQR');
lgd.FontSize = 20;
hold off
% saveas(gcf,'plots\b_traffic_7average.jpg')







% 3-day average effective reproductive number
Re_title = ["Region 1", "Region 2", "Region 3", "Region 4", "Region 5", "Region 6", "Region 7", "Dane County Total"];
figure
set(gcf, 'Position',  [200, 200, 1500, 550])
for i = 1:n_tracts
    subplot(2,ceil(n_tracts/2),i)
    plot(date,Re_3average(i,:),'LineWidth',width,'Color',[201,35,35]/255)
    hold on
    inBetween = [Re_25perc_3average(i,:), fliplr(Re_75perc_3average(i,:))];
    fill([date,flip(date)], inBetween, [201,35,35]/255, 'EdgeColor','none','facealpha',0.25);
    plot(date,ones(T+1,1),'-.','Color','b','LineWidth',width)
    xline(datetime(2020,5,26), 'LineWidth',width,'Color',[247,217,21]/255);
    xline(datetime(2020,6,15), 'LineWidth',width,'Color',[21,247,179]/255);
    xline(datetime(2020,7,2), 'LineWidth',width,'Color',[21,202,247]/255);
    xline(datetime(2020,7,13), 'LineWidth',width,'Color',[185,107,238]/255);
    hold off
    ylim([0,9.2])
    xlim([date(1)-5, date(end)+5])
    ylabel('R_e')
    title(Re_title(i))
    set(gca,'Fontsize',24)
    if(i==n_tracts)
        lgd = legend({'mean','IQR','R_e=1'},'Location','northwest');
        lgd.FontSize = 24;
    end

end
% saveas(gcf,'plots\Re_3average.jpg')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
set(gcf, 'Position',  [200, 200, 1200, 550])
for i = 1:n_tracts
    subplot(2,ceil(n_tracts/2),i)
    plot(date,IR_true(i,:),'-','LineWidth',3.5,'Color',[250 197 74]/255)
    hold on;
    
    I_plot = reshape(I_total_sample(i,:,:), Nsample, []);
    R_I_plot = reshape(R_I_total_sample(i,:,:), Nsample, []);
    plot(date,mean(I_plot)+mean(R_I_plot),'--','LineWidth',2.6,'Color',[44 44 230]/255)
    hold off;

    ylabel('I+R')  
    title("Region "+string(i))
    legend('true I+R', 'DA I+R','Location','northwest')
    set(gca,'Fontsize',font)
end
% saveas(gcf,'plots\IR.jpg')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
