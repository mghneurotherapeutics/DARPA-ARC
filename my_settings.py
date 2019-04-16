import os
import os.path as op
import numpy as np
import nibabel as nib
from pandas import read_csv

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
### Define parameters.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

sm = 6
thresholds = [0.0,0.5,0.7,0.9,1.1,1.3]
spaces = ['lh','rh','mni305']
version = 'Version20190405'
root_dir = '/autofs/space/lilli_002/users/JNeurosci_ARC/'
mri_dir = '/autofs/space/lilli_002/users/JNeurosci_ARC/fmri_first_levels/concat-sess/%s' % version
