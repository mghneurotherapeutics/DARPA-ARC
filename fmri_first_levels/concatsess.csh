#!/bin/csh

#Configure an Analysis
set HOME_DIR = `pwd`
set MY_VERSION = `cat {$HOME_DIR}/../params/VERSION.txt`
set ROOT_DIR  = `cat {$HOME_DIR}/../params/ROOT_DIR.txt`
set SESSID = $ROOT_DIR/fmri_first_levels/scripts/sessid
set OUT_DIR = $ROOT_DIR/fmri_first_levels/concat-sess/$MY_VERSION
set SPACES = ( `cat {$HOME_DIR}/../params/SPACES.txt` )
set FDs = ( `cat {$HOME_DIR}/../params/FD.txt` )
set FWHM = `cat {$HOME_DIR}/../params/FWHM.txt`
set MODELS = ( `cat {$HOME_DIR}/../params/MODELS.txt` )
set FS_SOURCE_DIR = `cat {$HOME_DIR}/../params/FS_SOURCE_DIR.txt`
set TASK = `cat {$HOME_DIR}/../params/TASK.txt`

## Call Freesurfer.
source $FS_SOURCE_DIR

cd $ROOT_DIR/fmri_first_levels

## Iteratively concatenate.
foreach MODEL ($MODELS)
foreach FD ($FDs)
foreach SPACE ($SPACES)
isxconcat-sess -sf $SESSID -analysis $MY_VERSION.$TASK.$MODEL.$FWHM.$FD.$SPACE -all-contrasts -o $OUT_DIR
mv $MY_VERSION.$TASK.$MODEL.$FWHM.$FD.$SPACE mkanalysis-sess/$MY_VERSION.$TASK.$MODEL.$FWHM.$FD.$SPACE
end
end
end

cd $HOME_DIR
