# IntraCounty-Mobility-SEIR
A human mobility flow-augmented stochastic SEIR-style epidemic modeling framework is developed, which combines with data assimilation and machine learning to reconstruct the historical growth trajectories of COVID-19 infection within a county.

‘data_0411_0814.mat’: Data needed to run the model for Dane County. (The codes of cleaning the data are provided in the folder ‘data_preparation’)

‘data_0311_0812.mat’: Data needed to run the model for Milwaukee County. (The codes of cleaning the data are provided in the folder ‘data_preparation’)

‘para_stochastic.m’: A fixed-point iteration is used to determine the coefficients of the OU process.

‘fun_EKI_stochastic.m’: Apply the Ensemble Kalman Filter.

‘SEIR_stochastic’: Run the model forward

‘plots.m’: Plot figures about the results of model.

‘case1.m’, ‘case2.m’, ‘case3.m’: Three scenario studies of Dane County.