#!/bin/csh

set HOME_DIR=`pwd`
set FWHM = `cat {$HOME_DIR}/../params/FWHM.txt`
set TASK = `cat {$HOME_DIR}/../params/TASK.txt`
set TR = `cat {$HOME_DIR}/../params/TR.txt`
set VERSION = `cat {$HOME_DIR}/../params/VERSION.txt`
set ROOT_DIR = `cat {$HOME_DIR}/../params/ROOT_DIR.txt`

cd $ROOT_DIR

foreach MODEL ( `cat {$HOME_DIR}/../params/MODELS.txt` )
foreach FD ( `cat {$HOME_DIR}/../params/THRESHOLDS.txt` )
foreach SPACE ( lh rh )

mkanalysis-sess \
  -surface fsaverage $SPACE \
  -fwhm $FWHM \
  -notask \
  -taskreg $VERSION.$MODEL.Control.par 1 \
  -taskreg $VERSION.$MODEL.par 1 \
  -nuisreg $VERSION.mc.par -1 \
  -tpexclude $VERSION.censor.$FD.par \
  -hpf 0.01 \
  -nskip 4 \
  -spmhrf 0 \
  -TR $TR \
  -fsd {$TASK}_001 \
  -per-run \
  -b0dc  \
  -analysis $VERSION.$TASK.$MODEL.$FWHM.$FD.$SPACE \
  -force

end

mkanalysis-sess \
  -mni305 2 \
  -fwhm $FWHM \
  -notask \
  -taskreg $VERSION.$MODEL.Control.par 1 \
  -taskreg $VERSION.$MODEL.par 1 \
  -nuisreg $VERSION.mc.par -1 \
  -tpexclude $VERSION.censor.$FD.par \
  -hpf 0.01 \
  -nskip 4 \
  -spmhrf 0 \
  -TR $TR \
  -fsd {$TASK}_001 \
  -per-run \
  -b0dc  \
  -analysis $VERSION.$TASK.$MODEL.$FWHM.$FD.$SPACE.mni305 \
  -force

end
end

cd $HOME_DIR
