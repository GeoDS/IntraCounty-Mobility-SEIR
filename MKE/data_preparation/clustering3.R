library(igraph)

infection = read.csv('Desktop/COVID19/Milwaukee/data/infection_cases/infection_0311_0512.csv')
ct_code = infection$ct_code
n_ct = nrow(infection)

flow_matrix = matrix(0,n_ct,n_ct)
flow = read.csv('Desktop/COVID19/Milwaukee/data/flow_ct_weekly2/weekly_ct2ct_03_02.csv')
index_o = match(flow$geoid_o, ct_code)
index_d = match(flow$geoid_d, ct_code)

for (j in 1:nrow(flow)){
  if ((!is.na(index_o[j])) & (!is.na(index_d[j])) & (index_o[j]!=index_d[j])){
    flow_matrix[index_o[j],index_d[j]] = flow$pop_flows[j]
  }
}

flow_graph = graph_from_adjacency_matrix(flow_matrix, mode="directed", weighted = TRUE, diag=FALSE, )
is_weighted(flow_graph)
flow_graph_undirected = as.undirected(flow_graph, mode = "each")

clustering1 = cluster_louvain(flow_graph_undirected) 
clustering2 = cluster_walktrap(flow_graph,steps=2) 

summary(as.factor(membership(clustering2)))

cluster1 =  as.numeric(membership(clustering1))
cluster2 =  as.numeric(membership(clustering2))
result = data.frame(ct_code,cluster1,cluster2)

modularity(clustering2)




