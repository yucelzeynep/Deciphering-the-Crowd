This folder includes loglikelihood and Kullback-Leibler divergences.


Likelihood:

Loglikelihood files are named as:
(d/v/theta)_ll_(coh/noncoh)_(global/local_min/local_max)

These do not depend on the Kullback-Leibler divergence. So it does not matter whether q->p or p->q,
q being the observed distribution and p being the modeled distribution.

Each likelihood file includes an Nx2 matrix. N is the number of coherent or non-coherent pairs based on the ground truth. The first column is the likelihood wrt modeled coherent distribution, the second column is the likelihood wrt modeled non-coherent distribution.

Divergence:

Divergence files are named as:
(q2p/p2q)_rho_(d/v/theta)_(coh/noncoh)

Each uncertinity (divergence ratio) file includes an Nx3 matrix. N is the number of coherent or non-coherent pairs based on the ground truth. The columns are organized as:
1: coh_sum(KL(a,b))/noncoh_sum(KL(a,b))
2: coh_min(a,b)/noncoh_min(a,b)
3: coh_max(a,b)/noncoh_max(a,b)

where KL stands for the Kullback-Leibler divergence. 
