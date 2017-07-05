import os, sys
import numpy as np
import nibabel as nib
from mne.filter import construct_iir_filter, filter_data
def demean(arr): return arr - arr.mean()

mri_dir = '/autofs/space/lilli_002/users/DARPA-ARC/'
subjects_dir = '/autofs/space/lilli_001/users/DARPA-Recons'
out_dir = '/space/sophia/2/users/DARPA-Behavior/notebooks/bayes/decision_making/NN_bayes_2016/motion'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
### Define parameters.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

subject = sys.argv[1]
decim = 250
tr = 1.75
high_pass = 100 # seconds
    
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
### Load and prepare masks.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

brainmask = os.path.join(mri_dir, subject, 'arc_001', '001', 'masks', 'brain.nii.gz')
brainmask = np.where( nib.load(brainmask).get_data(), 1, 0 ) # Binarize the mask

wm = os.path.join(mri_dir, subject, 'arc_001', '001', 'masks', 'wm.mgz')
wm = np.where( nib.load(wm).get_data(), 1, 0 ) # Binarize the mask

gm = brainmask - wm

## Reduce to indices of interest.
gm = np.vstack(np.where(gm))[:,::decim]
wm = np.vstack(np.where(wm))[:,::decim]
del brainmask

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
### Load and slice through EPI image.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

## Load data.
obj = nib.load(os.path.join(mri_dir, subject, 'arc_001', '001', 'fmcpr.nii'))
_,_,_,n_acq = obj.shape

## Preallocoate space for timeseries.
gmts = np.zeros((n_acq, gm.shape[-1]))
wmts = np.zeros((n_acq, wm.shape[-1]))

for n in range(n_acq):

    ## Slice image.
    acq = obj.dataobj[..., n]

    ## Store grey matter.
    gmts[n] += acq[gm[0],gm[1],gm[2]]

    ## Store white matter.
    wmts[n] += acq[wm[0],wm[1],wm[2]]

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
### Preprocessing data.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

## Construct highpass filter.
sfreq = 1. / tr
high_pass = 1. / high_pass
iir_params = dict(order=2, ftype='butter', output='sos') # Following Power et al. (2014)
iir_params = construct_iir_filter(iir_params, high_pass, None, sfreq, 'highpass', return_copy=False)  

## Filter data.
gmts = filter_data(gmts.T, sfreq, high_pass, None, method='iir', iir_params=iir_params, verbose=False)
wmts = filter_data(wmts.T, sfreq, high_pass, None, method='iir', iir_params=iir_params, verbose=False)

## De-mean (we'll save this for later.)
#gmts = np.apply_along_axis(demean, 1, gmts)
#wmts = np.apply_along_axis(demean, 1, wmts)

## Re-organize (center outwards).
gmts = gmts[ np.argsort( np.power( np.apply_along_axis(demean, 1, gm), 2 ).sum(axis=0) ) ]
wmts = gmts[ np.argsort( np.power( np.apply_along_axis(demean, 1, wm), 2 ).sum(axis=0) ) ]

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
### Save data.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

f = os.path.join(out_dir, '%s_arc_qc_data' %subject)
np.savez_compressed(f, gm=gmts, wm=wmts, iir_params=iir_params )
del gmts, wmts, obj
    
print 'Done.'
