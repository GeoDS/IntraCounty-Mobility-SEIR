[![MIT License][license-shield]][license-url]

<!-- PROJECT LOGO -->
<br />
<p align="center">
  <!--<a href="https://geods.geography.wisc.edu/">
    <img src="images/geods_safegraph_nsf_logo.jpg" alt="Logo" width="400">-->

  <h2 align="center">IntraCounty-Mobility-SEIR</h2>

  <p align="center">
    University of Wisconsin-Madison.
    <!--<br />
    <a href="https://geods.geography.wisc.edu/covid-19-physical-distancing">Website</a>
    ·
    <a href="http://geods.geography.wisc.edu/covid19/King_WA.html">View Demo</a>-->
  </p>
</p>

<!-- TABLE OF CONTENTS -->
## Table of Contents

* [Reference](#reference)
* [About the Project](#about-the-project)
* [File Descriptions](#file-descriptions)
* [License](#license)
* [Contact](#contact)
* [Acknowledgements](#acknowledgements)

<!-- Reference -->
## Reference
If you use this dataset and code in your research or applications, please refer this source:

Hou, X., Gao, S., Li, Q., Kang, Y., Chen, N., Chen, K., Rao, J., Ellenberg, J.S. and Patz, J.A. (2020). Intra-county modeling of COVID-19 infection with human mobility: assessing spatial heterogeneity with business traffic, age and race. preprint at medRxiv. https://www.medrxiv.org/content/10.1101/2020.10.04.20206763v1

```
@article{hou2020intra,
  title={Intra-county modeling of COVID-19 infection with human mobility: assessing spatial heterogeneity with business traffic, age and race},
  author={Hou, Xiao and Gao, Song and Li, Qin and Kang, Yuhao and Chen, Nan and Chen, Kaiping and Rao, Jinmeng and Ellenberg, Jordan S and Patz, Jonathan A},
  journal={medRxiv},
  year={2020},
  publisher={Cold Spring Harbor Laboratory Press}
}
```

<!-- ABOUT THE PROJECT -->
## About The Project


The COVID-19 pandemic is a global threat presenting health, economic and social challenges that continue to escalate. Meta-population epidemic modeling studies in the susceptible-exposed-infectious-removed (SEIR) style have played important roles in informing public health policy making to mitigate the spread of COVID-19. These models typically rely on a key assumption on the homogeneity of the population.  This assumption certainly cannot be expected to hold true in real situations; various geographic, socioeconomic and cultural environments affect the behaviors that drive the spread of COVID-19 in different communities. What's more, variation of intra-county environments creates spatial heterogeneity of transmission in different regions. To address this issue, we develop a new human mobility flow-augmented stochastic SEIR-style epidemic modeling framework with the ability to distinguish different regions and their corresponding behavior. This new modeling framework is then combined with data assimilation and machine learning techniques to reconstruct the historical growth trajectories of COVID-19 confirmed cases in two counties in Wisconsin. The associations between the spread of COVID-19 and business foot-traffic, race and ethnicity, and age are then investigated. The results reveal that in a college town (Dane County) the most important heterogeneity is age structure, while in a large city area (Milwaukee County) racial and ethnic heterogeneity becomes more apparent. Scenario studies further indicate a strong response of the spread rate on various reopening policies, which suggests that policymakers may need to take these heterogeneities into account very carefully when designing policies for mitigating the ongoing spread of COVID-19 and reopening. 

<!--
## Folder Structure
Data provided in this repository are separated into two folders <em>daily_flows</em> and <em>weekly_flows</em> to store daily flow data and weekly flow data.
The two folders are organized according to the geographic scale, where <em>ct2ct</em> indicates flows between census tract to census tract, <em>county2county</em> refers to flows between county to county, and <em>state2state</em> contains flow data originate from one state to others.
All files are stored in a csv format, which has been widely used for storing, transferring, and sharing data in the field of data science.
File names are formatted as <em>{data_type} \_ {spatial_scale}\_ {date}.csv</em>, e.g. <em>weekly_county2county_2020_03_02.csv</em> and <em>daily_state2state_2020_04_19.csv</em>.
Specifically, for weekly flow data, the dates in file name refers to the date of the Monday in that week but summarize all mobility flows in that week from Monday to Sunday.
Since the file size of flow data at census tract level exceeds the GitHub disk limit, each flow data file is split into 20 files, e.g. <em>weekly_ct2ct_2020_03_02_01.csv</em>.


The folders and files are organized as follows.   
```
project
|-- codes
|-- daily_flows
|   |-- state2state
|   |   |-- daily_state2state_2020_03_01.csv
|   |   |-- daily_state2state_2020_03_02.csv
|   |   `-- ...
|   |-- county2county
|   |   |-- daily_county2county_2020_03_01.csv
|   |   |-- daily_county2county_2020_03_02.csv
|   |   `-- ...
|   `-- ct2ct
|       |-- 2020_03_01
|       |   |-- daily_ct2ct_2020_03_01_01.csv
|       |   |-- daily_ct2ct_2020_03_01_02.csv
|       |   `-- ...
|       |-- 2020_03_02
|       |   |-- daily_ct2ct_2020_03_02_01.csv
|       |   |-- daily_ct2ct_2020_03_02_02.csv
|       |   `-- ...
|       `-- ...
`-- weekly_flows
|   |-- state2state
|   |   |-- weekly_state2state_2020_03_02.csv
|   |   |-- weekly_state2state_2020_03_09.csv
|   |   `-- ...
|   |-- county2county
|   |   |-- weekly_county2county_2020_03_02.csv
|   |   |-- weekly_county2county_2020_03_09.csv
|   |   `-- ...
|   `-- ct2ct
|       |-- 2020_03_02
|       |   |-- weekly_ct2ct_2020_03_02_01.csv
|       |   |-- weekly_ct2ct_2020_03_02_02.csv
|       |   `-- ...
|       |-- 2020_03_09
|       |   |-- weekly_ct2ct_2020_03_09_01.csv
|       |   |-- weekly_ct2ct_2020_03_09_02.csv
|       |   `-- ...
|       `-- ...
`-- weekly_country_flows
    |-- country2state
    |   |-- weekly_country2state_2020_03_02.csv
    |   |-- weekly_country2state_2020_03_09.csv
    |   `-- ...
    |-- country2county
    |   |-- weekly_country2county_2020_03_02.csv
    |   |-- weekly_country2county_2020_03_09.csv
    |   `-- ...
    `-- country2ct
        |-- weekly_country2ct_2020_03_02.csv
        |-- weekly_country2ct_2020_03_09.csv
        `-- ...
```
-->

## File Descriptions  
A description of all files in the repository is shown below:  
data_0411_0814.mat: The COVID-19 confirmed cases data needed to run the model for Dane County, WI, provided by the [Wisconsin Department of Health Services](https://data.dhsgis.wi.gov/datasets/covid-19-historical-data-by-census-tract/data?orderBy=GEOID). (The codes of cleaning the data are provided in the folder ‘data_preparation’)

data_0311_0812.mat: The COVID-19 confirmed cases data needed to run the model for Milwaukee County, WI, provided by the [Wisconsin Department of Health Services](https://data.dhsgis.wi.gov/datasets/covid-19-historical-data-by-census-tract/data?orderBy=GEOID). (The codes of cleaning the data are provided in the folder ‘data_preparation’)

para_stochastic.m: A fixed-point iteration is used to determine the coefficients of the OU process.

fun_EKI_stochastic.m: Apply the Ensemble Kalman Filter.

SEIR_stochastic: Run the model forward

plots.m: Plot figures about the results of model.

case1.m, case2.m, case3.m: Three scenario studies of Dane County.


<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.



<!-- CONTACT -->
## Contact

Song Gao - [@gissong](https://twitter.com/gissong) - song.gao at wisc.edu  
Qin Li - [Mathematics](http://www.math.wisc.edu/~qinli/index.html) - qinli at math.wisc.edu 
Xiao Hou - [Mathematics](https://www.math.wisc.edu/grad-students) - xhou9	at wisc.edu  
Yuhao Kang - [@YuhaoKang](https://twitter.com/YuhaoKang) - yuhao.kang at wisc.edu  

Project Link: [https://github.com/GeoDS/COVID19USFlows](https://github.com/GeoDS/COVID19USFlows)  



<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
* [SafeGraph](https://www.safegraph.com/)
* [GeoDS Lab](https://geods.geography.wisc.edu/)

## Funding
We would like to thank the SafeGraph Inc. for providing the anonymous and aggregated place visits and human mobility flow data. S.G., Q.L., K.C, and J.P. acknowledge the funding support provided by the National Science Foundation (Award No. BCS-2027375). J.E. acknowledge the funding support provided by the National Science Foundation (Award No. DMS-1700884). Q.L., N.C. and X.H. are also supported by Data Science Initiative, provided by the University of Wisconsin - Madison Office of the Chancellor and the Vice Chancellor for Research and Graduate Education with funding from the Wisconsin Alumni Research Foundation. Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Science Foundation.

<!-- MARKDOWN LINKS & IMAGES -->
[license-shield]: https://img.shields.io/github/license/othneildrew/Best-README-Template.svg?style=flat-square
[license-url]: https://github.com/GeoDS/COVID19USFlows/blob/master/LICENSE.txt
