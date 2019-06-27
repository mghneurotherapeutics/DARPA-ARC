#!/bin/csh

set HOME_DIR=`pwd`
set FWHM = `cat {$HOME_DIR}/../params/FWHM.txt`
set TASK = `cat {$HOME_DIR}/../params/TASK.txt`
set TR = `cat {$HOME_DIR}/../params/TR.txt`
set MY_VERSION = `cat {$HOME_DIR}/../params/VERSION.txt`
set ROOT_DIR = `cat {$HOME_DIR}/../params/ROOT_DIR.txt`
set FS_SOURCE_DIR = `cat {$HOME_DIR}/../params/FS_SOURCE_DIR.txt`

if ("$1" == "-check_threshs") then
  set THRESHOLDS = ( `cat {$HOME_DIR}/../params/THRESHOLDS.txt` )
  set MODELS = ( `head -1 {$HOME_DIR}/../params/MODELS.txt` )
else
  set THRESHOLDS = ( `cat {$HOME_DIR}/../params/FD.txt` )
  set MODELS = ( `cat {$HOME_DIR}/../params/MODELS.txt` )
endif

source $FS_SOURCE_DIR

cd $ROOT_DIR/fmri_first_levels

mkdir -p mkanalysis-sess

foreach MODEL ($MODELS)
set REGRESSOR_TEXT = `cat {$HOME_DIR}/../params/$MODEL.REGRESSOR_TEXT.txt`
foreach FD ($THRESHOLDS)
foreach SPACE ( lh rh )

mkanalysis-sess \
  -surface fsaverage $SPACE \
  -fwhm $FWHM \
  -notask \
  $REGRESSOR_TEXT \
  -nuisreg $MY_VERSION.mc.par -1 \
  -tpexclude $MY_VERSION.censor.$FD.par \
  -hpf 0.01 \
  -nskip 4 \
  -spmhrf 0 \
  -TR $TR \
  -fsd {$TASK}_001 \
  -per-run \
  -b0dc  \
  -analysis $MY_VERSION.$TASK.$MODEL.$FWHM.$FD.$SPACE \
  -force

end

mkanalysis-sess \
  -mni305 2 \
  -fwhm $FWHM \
  -notask \
  $REGRESSOR_TEXT \
  -nuisreg $MY_VERSION.mc.par -1 \
  -tpexclude $MY_VERSION.censor.$FD.par \
  -hpf 0.01 \
  -nskip 4 \
  -spmhrf 0 \
  -TR $TR \
  -fsd {$TASK}_001 \
  -per-run \
  -b0dc  \
  -analysis $MY_VERSION.$TASK.$MODEL.$FWHM.$FD.mni305 \
  -force

end
end

cd $HOME_DIR
