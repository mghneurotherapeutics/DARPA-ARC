import os, sys
import numpy as np
from pandas import read_csv
from scipy.sparse import coo_matrix
from mne.stats.cluster_level import _find_clusters as find_clusters

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
### Define parameters.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
'''Input from cmdline: Space Contrast Permutations'''
args = sys.argv[1:]

## I/O parameters.
space = args[0]
contrast = args[1]
version = 'Version20190405'
root_dir = '/autofs/space/lilli_002/users/JNeurosci_ARC/'
sm = 6
fd = 0.9

## Permutation parameters.
permutations = int(args[2])

## TFCE parameters.
threshold = dict(start=0.1, step=0.1, h_power=2, e_power=0.5)
tail = 0
max_step = 1

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
### Load and prepare data.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

def load_sparse_coo(filename):
    npz = np.load(filename)
    M,N = npz['shape']
    return coo_matrix( (npz['data'], (npz['row'],npz['col'])), (M,N) )

out_dir = os.path.join(root_dir, 'fmri_second_levels', '%s.%s.%s.%s.%s' %(version, sm, fd, space, contrast))

## Load data.
npz = np.load(os.path.join(out_dir, 'first_levels.npz'))
ces = npz['ces']
cesvar = np.abs( 1. / npz['cesvar'] )

## Define indices.
connectivity = load_sparse_coo(os.path.join(root_dir, 'fmri_second_levels', '%s_%s_connectivity.npz' % (version, space)))
index,  = np.where(~np.isinf(cesvar).sum(axis=1).astype(bool))
include = ~np.isinf(cesvar).sum(axis=1).astype(bool)
    
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
### Setup for permutation testing.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

## Load subject information.
info = read_csv(os.path.join(root_dir, 'demographics.csv'))
info = info[~info.Exlude].reset_index()
n_subj, _ = info.shape

## Build Design Matrix.
X = np.zeros((n_subj,2))
X[:,0] = 1                                        # Intercept
X[:,1] = np.where(info.Scanner == 'Trio', 0, 1)   # Scanner
n_subj, n_pred = X.shape

## If specified, load precomputed sign flips.
if permutations: 
    sign_flips = np.load(os.path.join(root_dir, 'fmri_second_levels', 
                                      'permutations',
                                      '%s_sign_flips_%s.npy' % (version, permutations)))
else: 
    sign_flips = np.ones((1,n_subj))
n_shuffles = sign_flips.shape[0]

## Preallocate arrays for results.
shape = [n_shuffles] + list(ces.shape[:-1])
Bmap = np.zeros(shape)
Fmap = np.zeros(shape)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
### Main loop.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

'''
Following the instructions of Winkler et al. (2014), we use the Freedman and Lane (1983)
permutation procedure. This allows us to precompute a number of values ahead of time.

To understand the WLS computations, please see:
https://github.com/statsmodels/statsmodels/blob/master/statsmodels/base/model.py
https://github.com/statsmodels/statsmodels/blob/master/statsmodels/regression/linear_model.py
'''

def wls(X,Y,W):
    B = np.linalg.inv(X.T.dot(W).dot(X)).dot(X.T).dot(W).dot(Y)
    ssr = W.dot( np.power(Y - np.dot(X,B),2) ).sum()
    scale = ssr / (n_subj - n_pred)
    cov_p = np.linalg.inv(X.T.dot(W).dot(X)) * scale
    F = np.power(B[0],2) * np.power(cov_p[0,0],-1)
    return B[0], F

## Loop it!
for n, sf in enumerate(sign_flips):
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
    ### Compute statistics.
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
    #
    for m in index:
        #
        ## Update variables.
        W = np.diag(cesvar[m])
        Y = ces[m]
        #
        ## Permute values.
        ## See Winkler et al. (2014), pg. 385
        ## To compute Hat Matrix, see: https://en.wikipedia.org/wiki/Projection_matrix and 
        Z = X[:,1:]
        ZZ = Z.dot( np.linalg.inv( Z.T.dot(W).dot(Z) ) ).dot(Z.T).dot(W)
        Rz = np.identity(n_subj) - ZZ
        Y = np.diag(sf).dot(Rz).dot(Y)
        #
        ## Perform WLS.
        Bmap[n,m], Fmap[n,m] = wls(X,Y,W) 
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
    ### Perform TFCE.
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
    #
    _, Fmap[n] = find_clusters(Fmap[n], threshold, tail=tail, connectivity=connectivity, 
                               include=include, max_step=max_step, show_info=False)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
### Save results.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#  
        
if not permutations: f = os.path.join(out_dir, '%s_%s_obs' %(space, contrast))
else: f = os.path.join(out_dir, '%s_%s_perm-%s' %(space, contrast, permutations)) 
np.savez_compressed(f, Bmap=Bmap, Fmap=Fmap)
    
print('Done.')
