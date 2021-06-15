# Deciphering the crowd: Modeling and Identification of Pedestrian Group Motion

This repository contains the resources necessary for reproducing the results reported in our manuscript [1]. The implementation is done in Matlab7 with no specific dependencies.

Specifically, the repository is organized as collection of the data set, main routine(s), and auxiliaries. The raw data set analyzed during the study is publicly available at [2]. Please see [3] and [4] for a detailed analysis of the data set considering the different density conditions. In this repository, we provide a post-processed (i.e. normalized) version of the raw data, such that the data points collected over a certain duration (100 msec) are averaged. That is, there is a single data point for each 100 msec, which is the average of the coordinates registered within the corresponding time window.

Please see below for a brief explanation of each component. For a high-level overview of each script, you may see the docstrings appearing on the top of the  scripts and for low-level descriptions please look into the functions.

**Data and annotations**

###### Smooth-nonrepeating
The raw range readings obtained from the sensors (Hokuyo UTM-30LX) are fed to HumanTracker [5] to track and extract the trajectory of each single mobile entitity. Since the output concering entire recordings is quite large in size, we divided it into 15 segments (see part1~part15 under apita_dataset/smooth_nonrepeating). 

The contents of these files are organized as below:
    >col 1 : Unix time stamp
    col 2 : ID
    col 3 : x-coordinate
    col 4 : y-coordinate
    col 5 : top feat - number of samples
    col 6 : top feat - rmax/rmin
    col 7 : top feat - atan(evector_max)
    col 8 : bot feat - number of samples
    col 9 : bot feat - rmax/rmin
    col 10: bot feat - atan(evector_max)
    
 In addition, for every data segment (part1~part15), there is one file concerning each of the below.

###### Labels

The mobile entities are labeled according to their type. Each row of the labels matrix involves two entries, where the first one is the ID of the entity and the second one is the type of the entity. Entity types are coded as below
>Human: 1\
  Wheelchair: 2\
  Shopping cart: 3\
  Stroller: 4\
  Cart: 5\
  Not annotated: 0

###### Overlaps
Some pedestrians have the some of their trajectory in part-(i) and the remaining in part-(i+1). The files under the folder overlaps contain the IDs of such pedestrians.

###### Pairs
The pedestrian groups are labeled according to their type. The possible types of pairs are human-human,  human-shopping-cart,   human-stroller, and  human-cart. Each row of the pairs matrix involves three entries as below
  >col 1: type of the pair\
  col 2: ID1\
  col 3: ID2
  
Group types are coded as below:

>Human-human: 2\
    Human-shopping-cart: 3\
    Human-stroller: 4\
    Human-cart: 5


###### Velocity
Velocity is computed based on path-i files and by taking the displacement between every other data point and dividing it the corresponding time interval.

**Main routines**

The main routine builds one model for each of interpersonal distance, angle between velocity vectors and dot product of velocities. These models are created by d_modeling/d_modeling.m, theta_modeling/theta_modeling.m and vdot_modeling/vdot_modeling.m, respectively. 

For building each model, the data is shuffled and split it into training and testing subsets. For the details of the models (Rice, Von Mises distributions) and the hyper-parameters to be calibrated, please see the article. In addition, in corresponding sub-folders, you may find the auxiliary files, which are necessary for optimization. 

The function main.m does a single set of training-testing, whereas main_loops.m repeats this procedure 50 times and reports descriptive statistics.

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
Potential for the dynamics of pedestrians in a socially interacting group, \
Physical Review E, Vol. 89, No. 1, 012811, 2014

[4] Francesco Zanlungo, Drazen Brscic, and Takayuki Kanda \
Pedestrian group spatial size scaling under growing density conditions, \
Physical review E, Vol. 91, No. 6, 062810, 2015 

[5] Dylan F. Glas, Takahiro Miyashita, Hiroshi Ishiguro, and Norihiro Hagita\
Laser-based tracking of human position and orientation using parametric shape modeling\
Advanced robotics 23, no. 4 (2009): 405-428.

[6] Zeynep Yücel, Francesco Zanlungo, Tetsuhi Ikeda, Takahiro Miyashita, Norihiro Hagita\
Modeling Indicators of Coherent Motion\
International Conference on Intelligent Robots and Systems, pp. 2134-2140, Oct. 2012, IROS 2012 (Algarve, Portugal).

[6] Zeynep Yücel, Takahiro Miyashita, Norihiro Hagita\
Modeling and Identification of Group Motion via Compound Evaluation of Positional and Directional Cues\
International Conference on Pattern Recognition, pp. 1172-1176, Nov. 2012, ICPR 2012 (Tsukuba, Japan).
