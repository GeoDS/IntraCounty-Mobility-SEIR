IR_data = readtable("mke_infection_0311_0812.csv",'ReadRowNames',true,'ReadVariableNames',true);

pop_data = readtable('mke_race_ct.csv','ReadRowNames',true,'ReadVariableNames',true);
pop_density_data = readtable('mke_ct_shp.csv','ReadRowNames',true,'ReadVariableNames',true);
pop_density_data = pop_density_data(:,6);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clusters = readtable("mke_clustering_weekly_03_02.csv",'ReadVariableNames',true, 'ReadRowNames',true);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clusters = table2array(clusters);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clusters = clusters(:,2);
n_clusters = max(clusters);
n_ct = length(clusters);

tracts_table = join(IR_data, pop_data, 'Keys', 'RowNames');
tracts_table = join(tracts_table, pop_density_data, 'Keys', 'RowNames');


tracts_matrix = table2array(tracts_table);

n_days = size(IR_data,2);
n_days_traffic = 148;
T = n_days - 1;

IR_all = tracts_matrix(:,1:n_days);    % cumulative infection, i.e. I+R
IR_true = zeros(n_clusters,n_days);
N_all = tracts_matrix(:,n_days+1);    % population
N = zeros(n_clusters,1);
area_all = tracts_matrix(:,n_days+16);
area = zeros(n_clusters,1);

race_all = tracts_matrix(:,(n_days+2):(n_days+8));
race = zeros(n_clusters,7);

for i = 1:n_ct
    c = clusters(i);
    IR_true(c,:) = IR_true(c,:) + IR_all(i,:);
    N(c) = N(c) + N_all(i);
    area(c) = area(c) + area_all(i);
    race(c,:) = race(c,:) + race_all(i,:);
end
race = race ./ (N * ones(1,7));
pop_density = N./area;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% traffic matrix
n_tr = zeros(n_clusters,n_clusters,n_days_traffic);
ct_code = readmatrix("mke_infection_0311_0812.csv", 'range', 'A2:A297');
n_tr_diag = zeros(n_clusters,n_days_traffic);


names_days = ["01";"02";"03";"04";"05";"06";"07";"08";"09"];
names_days = [names_days;string((10:31)')];
march = strcat("./flow/daily_ct2ct_03_",names_days,".csv");
march  =  march(11:end);
april = strcat("./flow/daily_ct2ct_04_",names_days,".csv");
april  =  april(1:30);
may = strcat("./flow/daily_ct2ct_05_",names_days,".csv");
june = strcat("./flow/daily_ct2ct_06_",names_days,".csv");
june = june(1:30);
july = strcat("./flow/daily_ct2ct_07_",names_days,".csv");
august = strcat("./flow/daily_ct2ct_08_",names_days,".csv");
august = august(1:8);
names_days = [march;april;may;june;july;august];




for i = 1:n_days_traffic
    traffic = readtable(names_days(i), 'ReadVariableNames',true, 'ReadRowNames',false);
    traffic = [traffic(:,1:2) traffic(:,9)];
    traffic = table2array(traffic);
    
    for j = 1:length(traffic)
        index_o = find(ct_code == traffic(j,1));
        index_d = find(ct_code == traffic(j,2));
        if (~isempty(index_o)) & (~isempty(index_d))
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


%%%%%%%%%%%%%%%%%%%
save('data_0311_0812.mat', 'N', 'n_tr', 'IR_true', 'T', 'pop_density','race', 'n_tr_diag')
%%%%%%%%%%%%%%%%%%%


