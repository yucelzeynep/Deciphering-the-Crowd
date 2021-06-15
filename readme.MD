# Deciphering the crowd: Modeling and Identification of Pedestrian Group Motion

This repository contains the resources necessary for reproducing the results reported in our manuscript [1]. The implementation is done in Matlab7 with no specific dependencies.

Specifically, the repository is organized as collection data set, main routine(s), and auxiliaries. The raw data set analyzed during the study is publicly available at [2]. Please see [3] and [4] for a detailed analysis of the data set considering the different density conditions. In this repository, we provide a post-processed (i.e. normalized) version of the raw data, such that the data points collected over a certain duration (100 msec) are averaged. That is, there is a single data point for each 100 msec, which is the average of the coordinates registered within the corresponding time window.

Please see below for brief explanation of each software component. For a high-level overview of each script, you may see the docstrings appearing on the top of the  scripts and for low-level descriptions please look into the functions.

**Data and annotations**

**Main routines**

###### Benchmark method

**References**

[1] Zeynep Yücel, Francesco Zanlungo, Tetsuhi Ikeda, Takahiro Miyashita, Norihiro Hagita\
Deciphering the crowd: Modeling and identification of pedestrian group motion\
Sensors, Vol. 13, No. 1, pp. 875-897, Jan. 2013.\
doi: 10.3390/s130100875

[2] Drazen Brscic\
ATR-IRC. Dataset: Pedestrian tracking with group annotations\
Available from: http://www.irc.atr.jp/sets/groups/. 

[3] Francesco Zanlungo, Tetsushi Ikeda, and Takayuki Kanda \
"Potential for the dynamics of pedestrians in a socially interacting group," \
Physical Review E, Vol. 89, No. 1, 012811, 2014

[4] Francesco Zanlungo, Drazen Brscic, and Takayuki Kanda \
"Pedestrian group spatial size scaling under growing density conditions," \
Physical review E, Vol. 91, No. 6, 062810, 2015 

[5] Zeynep Yücel, Francesco Zanlungo, Tetsuhi Ikeda, Takahiro Miyashita, Norihiro Hagita\
Modeling Indicators of Coherent Motion\
International Conference on Intelligent Robots and Systems, pp. 2134-2140, Oct. 2012, IROS 2012 (Algarve, Portugal).


[6] Zeynep Yücel, Takahiro Miyashita, Norihiro Hagita\
Modeling and Identification of Group Motion via Compound Evaluation of Positional and Directional Cues\
International Conference on Pattern Recognition, pp. 1172-1176, Nov. 2012, ICPR 2012 (Tsukuba, Japan).
