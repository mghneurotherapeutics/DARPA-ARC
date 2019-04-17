#!/bin/csh

#Configure an Analysis
set HOME_DIR = `pwd`
set VERSION = `cat {$HOME_DIR}/../params/VERSION.txt`
set ROOT_DIR  = `cat {$HOME_DIR}/../params/ROOT_DIR.txt`
set SESSID = $ROOT_DIR/scripts/sessid
set OUT_DIR = $ROOT_DIR/concat-sess/$VERSION
set SPACES = ( `cat {$HOME_DIR}/../params/SPACES.txt` )
set FDs = ( `cat {$HOME_DIR}/../params/FDs.txt` )
set FWHM = `cat {$HOME_DIR}/../params/FWHM.txt`
set MODELS = ( `cat {$HOME_DIR}/../params/MODELS.txt` )
set FS_SOURCE_DIR = `cat {$HOME_DIR}/../params/FS_SOURCE_DIR.txt`
set CONDITIONS = ( `cat {$HOME_DIR}/../params/CONDITIONS.txt` )

## Call Freesurfer.
source $FS_SOURCE_DIR
cd $ROOT_DIR

## Iteratively concatenate.
foreach MODEL ($MODELS)
foreach FD ($FDs)
foreach SPACE ($SPACES)
isxconcat-sess -sf $SESSID -analysis $VERSION.$TASK.$MODEL.$FWHM.$FD.$SPACE -all-contrasts -o $OUT_DIR
end
end
end

cd $HOME_DIR
