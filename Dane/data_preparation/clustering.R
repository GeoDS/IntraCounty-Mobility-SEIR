library(igraph)

data_ctcode = read.csv('Desktop/COVID19/Dane/data/dane_ctcode_0629.csv')
ct_code = data_ctcode$GEOID
n_ct = nrow(data_ctcode)

flow_matrix = matrix(0,n_ct,n_ct)
flow = read.csv('Desktop/COVID19/Dane/data/weekly/weekly_ct2ct_03_02.csv')
index_o = match(flow$geoid_o, ct_code)
index_d = match(flow$geoid_d, ct_code)

for (j in 1:nrow(flow)){
  if ((!is.na(index_o[j])) & (!is.na(index_d[j])) & (index_o[j]!=index_d[j])){
    flow_matrix[index_o[j],index_d[j]] = flow$pop_flows[j]
  }
}

flow_graph = graph_from_adjacency_matrix(flow_matrix, mode="directed", weighted = TRUE, diag=FALSE, )
flow_graph_undirected = as.undirected(flow_graph, mode = "each") 

clustering1 = cluster_louvain(flow_graph_undirected) 
clustering2 = cluster_walktrap(flow_graph,steps = 4)
# membership(clustering2)
summary(as.factor(membership(clustering2)))

cluster1 =  as.numeric(membership(clustering1))
cluster2 =  as.numeric(membership(clustering2))
result = data.frame(ct_code,cluster1,cluster2)

modularity(clustering2)




