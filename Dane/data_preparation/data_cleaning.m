IR_data = readtable("infection_0411_0814.csv",'ReadRowNames',true,'ReadVariableNames',true);
pop_data = readtable('ct_pop_density.csv','ReadRowNames',true,'ReadVariableNames',true);
pop_data = pop_data(:,2);
area_data = readtable('dane_ct_shp.csv','ReadRowNames',true,'ReadVariableNames',true);
area_data = area_data(:,6);

%%%%%%%%%%%%%%%%%%%%%%
clusters = readtable("clustering_weekly_03_02.csv",'ReadVariableNames',true, 'ReadRowNames',true);
clusters = clusters(:,2);
%%%%%%%%%%%%%%%%%%%%%%%


n_clusters = max(clusters);
n_ct = length(clusters);

tracts_table = join(IR_data, pop_data, 'Keys', 'RowNames');
tracts_table = join(tracts_table, area_data, 'Keys', 'RowNames');
tracts_matrix = table2array(tracts_table);

n_days = size(IR_data,2);
n_days_traffic = n_days - 7;
T = n_days - 1;

IR_all = tracts_matrix(:,1:n_days);    % cumulative infection, i.e. I+R
IR_true = zeros(n_clusters,n_days);
N_all = tracts_matrix(:,n_days+1);    % population
N = zeros(n_clusters,1);
area_all = tracts_matrix(:,n_days+2);
area = zeros(n_clusters,1);


for i = 1:n_ct
    c = clusters(i);
    IR_true(c,:) = IR_true(c,:) + IR_all(i,:);
    N(c) = N(c) + N_all(i);
    area(c) = area(c) + area_all(i);
end
pop_density = N./area;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% traffic matrix
n_tr = zeros(n_clusters,n_clusters,n_days_traffic);
ct_code = readmatrix("infection_0411_0814.csv", 'range', 'A2:A106');
n_tr_diag = zeros(n_clusters,n_days_traffic);


names_days = ["01";"02";"03";"04";"05";"06";"07";"08";"09"];
names_days = [names_days;string((10:31)')];
april = strcat("flow_ct_daily/daily_ct2ct_04_",names_days,".csv");
april  =  april(11:30);
may = strcat("flow_ct_daily/daily_ct2ct_05_",names_days,".csv");
june = strcat("flow_ct_daily/daily_ct2ct_06_",names_days,".csv");
june = june(1:30);
july = strcat("flow_ct_daily/daily_ct2ct_07_",names_days,".csv");
august = strcat("flow_ct_daily/daily_ct2ct_08_",names_days,".csv");
august = august(1:7);
names_days = [april;may;june;july;august];




for i = 1:n_days_traffic
    traffic = readtable(names_days(i), 'ReadVariableNames',true, 'ReadRowNames',false);
    traffic = [traffic(:,1:2) traffic(:,9)];
    traffic = table2array(traffic);
    
    for j = 1:length(traffic)
        index_o = find(ct_code == traffic(j,1));
        index_d = find(ct_code == traffic(j,2));
        if (~isempty(index_o)) && (~isempty(index_d))
            c1 = clusters(index_o);
            c2 = clusters(index_d);
            if c1 ~= c2
                n_tr(c2,c1,i) = n_tr(c2,c1,i) + traffic(j,3);
            else
                n_tr_diag(c1,i) = n_tr_diag(c2,i) + traffic(j,3);
            end
            
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%
save('data_0411_0814.mat', 'N', 'n_tr', 'IR_true', 'T', 'pop_density', 'n_tr_diag')
%%%%%%%%%%%%%%%%%%%%%%%

