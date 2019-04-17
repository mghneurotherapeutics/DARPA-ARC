import os, time
import os.path as op
import numpy as np
import nibabel as nib
from pandas import DataFrame, read_csv
from pylab import plt
import pickle
import nibabel as nib

def param_to_text(name, param):
    name = name.upper()
    param_dir = './params'
    fname = op.join(param_dir, '%s.txt' % name)
    if op.isfile(fname):
        return
    if not op.isdir(param_dir):
        os.makedirs(param_dir)
    with open(fname, 'w') as f:
        if isinstance(param, list) or isinstance(param, tuple):
            for p in param:
                if isinstance(p, list) or isinstance(p, tuple):
                    f.write('.'.join([str(p1) for p1 in p]) + '\n')
                else:
                    f.write(str(p) + '\n')
        else:
            f.write(str(param))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
### Define parameters.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

task = 'arc'
param_to_text('task', task)
paradigm = 'ser'  # Slow, event-related
param_to_text('paradigm', paradigm)
session = 1
param_to_text('session_short', session)
param_to_text('session','%03d' % session)
modality = 'mri'
param_to_text('modality', modality)
stan_models = ['hierarchical', 'non-hierarchical']
models = [('hierarchical', 'DelibMod', 'VariableEpochs'), ('non-hierarchical', 'DelibMod', 'VariableEpochs'),
          ('hierarchical', 'DelibMod', 'FixedEpochs'), ('non-hierarchical', 'DelibMod', 'FixedEpochs'),
          ('parameter', 'Risk', 'VariableEpochs'), ('parameter', 'Reward', 'VariableEpochs'),
          ('parameter', 'Risk', 'FixedEpochs'), ('parameter', 'Reward', 'FixedEpochs')]
param_to_text('models', models)
sm = 6
param_to_text('fwhm', sm)
thresholds = [0.0, 0.5, 0.7, 0.9, 1.1, 1.3]
param_to_text('thresholds', thresholds)
spaces = ['lh','rh','mni305']
param_to_text('spaces', spaces)
version = 'Version20190416'
param_to_text('version', version)
choice_time = 3.5  # how long subject had to choose including 0.5 risk presentation when no choice is able
n_acq = 977
tr = 1.75
param_to_text('tr', tr)
param_to_text('tr_ms', tr*1000)
sfreq = 1e2
fd = 0.9  # The chosen framewise displasemnt, if changed delete FD.txt param file as well
param_to_text('FD', fd)
n_permutations = 5000
inc = 100
psc_threshold = 1.301
overlay = 'psc'
surface = 'inflated'

fs_source_dir = '/usr/local/freesurfer/nmr-stable53-env'
param_to_text('fs_source_dir', fs_source_dir)
fs_dir = '/autofs/space/lilli_001/users/DARPA-Recons/'
param_to_text('subjects_dir', fs_dir)
root_dir = '/autofs/space/lilli_002/users/JNeurosci_ARC/'
param_to_text('root_dir', root_dir)
subj_dir = '/autofs/space/lilli_001/users/DARPA-Recons/fscopy/'
mri_dir = '/autofs/space/lilli_002/users/DARPA-ARC/' #
param_to_text('mri_dir', mri_dir)
behavior_dir = '/autofs/space/lilli_001/users/DARPA-Behavior/arc/csv'
param_to_text('behavior_dir', behavior_dir)
concat_sess_dir = '/autofs/space/lilli_002/users/JNeurosci_ARC/fmri_first_levels/concat-sess/%s' % version
asegf = '/autofs/space/lilli_001/users/DARPA-Recons/fsaverage/mri.2mm/aseg.mgz'
img_dir = op.join(root_dir, 'plots/%s/second_levels' % version)

rois = ['caudalanteriorcingulate', 'rostralanteriorcingulate', 'posteriorcingulate',
        'superiorfrontal', 'medialorbitofrontal', 'rostralmiddlefrontal', 'caudalmiddlefrontal',
        'parsopercularis', 'parstriangularis', 'parsorbitalis', 'lateralorbitofrontal', 'insula']

roi_dict = {18:'Left-Amygdala', 11:'Left-Caudate', 17:'Left-Hippocampus', 12:'Left-Putamen', 
            54:'Right-Amygdala', 50:'Right-Caudate', 53:'Right-Hippocampus', 51:'Right-Putamen'}


colors = [[0.78329874347238, 0.687243385525311, 0.8336793640080622],
          [0.1257208769520124, 0.47323337360924367, 0.707327968232772],
            [0.999907727802501, 0.5009919264737298, 0.005121107311809869],
          [0.21171857311445125, 0.6332641510402455, 0.1812226118410335],
          [0.6941176652908325, 0.3490196168422699, 0.1568627506494522],
          [0.42485198495434734, 0.2511495584950722, 0.6038600774372326],
          [0.983206460055183, 0.5980161709820524, 0.5942330108845937],
          [0.9917570170234231, 0.7464821371669862, 0.4340176893507733],
          [0.8905959311653586, 0.10449827132271793, 0.111080354627441],
          [0.9976009228650261, 0.9948942715046452, 0.5965244373854468],
          [0.6889965575115352, 0.8681737867056154, 0.5437601194662207],
          [0.6509804129600525, 0.8078431487083435, 0.8901960849761963]]

label_dir = os.path.join(subj_dir, 'label', 'dkt40')

df = read_csv(op.join(root_dir,'demographics.csv'))
info = df[~df.Exlude].reset_index()
subjects = df.loc[~df.Exlude, 'Subject'].values

## Build Design Matrix.
X = np.zeros((len(subjects),2))
X[:,0] = 1                                        # Intercept
X[:,1] = np.where(info.Scanner == 'Trio', 0, 1)   # Scanner
n_subj, n_pred = X.shape

categories = ['Subject','Trial','RiskType','Reward','ResponseType','ddb','RT','RiskOnset','ShockOnset']
merge_on = ['Subject','RiskType','Reward','RiskOnset']  # what categories to sort DataFrame by

def trim(im):
    bg = Image.new(im.mode, im.size, im.getpixel((0,0)))
    diff = ImageChops.difference(im, bg)
    diff = ImageChops.add(diff, diff, 2.0, -100)
    bbox = diff.getbbox()
    if bbox:
        return im.crop(bbox)


def prepare_image(arr, space):
    npz = np.load(op.join(root_dir, 'fmri_second_levels/%s_%s_connectivity.npz' % (version, space)))
    image = np.zeros_like(npz['mapping'], dtype=float)
    #
    if not space == 'mni305': 
        image[npz['vertices']] += arr
    else:
        x,y,z = npz['voxels'].T
        image[x,y,z] += arr
    #
    for _ in range(4 - len(image.shape)): image = np.expand_dims(image,-1)
    return image

from scipy.sparse import coo_matrix

def load_sparse_coo(filename):
    npz = np.load(filename)
    M,N = npz['shape']
    return coo_matrix( (npz['data'], (npz['row'],npz['col'])), (M,N) )


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
