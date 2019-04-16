#!/bin/csh

#Configure an Analysis
set VERSION = Version20190405
set ROOT_DIR  = /autofs/space/lilli_002/users/JNeurosci_ARC/fmri_first_levels
set SESSID = $ROOT_DIR/scripts/sessid
set OUT_DIR = $ROOT_DIR/concat-sess/$VERSION
set SPACES = (lh rh mni305)
set FDs = (0.0 0.5 0.7 0.9 1.1 1.3)
set FWHM = 6

## Call Freesurfer.
source /usr/local/freesurfer/nmr-stable53-env
cd $ROOT_DIR

## Iteratively concatenate.
foreach FD ($FDs)
foreach SPACE ($SPACES)
isxconcat-sess -sf $SESSID -analysis $VERSION.$FWHM.$FD.$SPACE -all-contrasts -o $OUT_DIR
end
end

cd $ROOT_DIR/scripts
