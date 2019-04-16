#!/bin/csh

set FWHM = 6
set TR = 1.75
set FDs = (0.0 0.5 0.7 0.9 1.1 1.3)
set fsd = arc_001
set VERSION = Version20190405
set HOME_DIR = `pwd`

cd /autofs/space/lilli_002/users/JNeurosci_ARC/fmri_first_levels

foreach FD ($FDs)
foreach SPACE (lh rh)

mkanalysis-sess \
  -surface fsaverage $SPACE \
  -fwhm $FWHM \
  -notask \
  -taskreg $VERSION.Delib.par 1 \
  -taskreg $VERSION.DelibMod.par 1 \
  -taskreg $VERSION.FixedEpochs.par 1 \
  -taskreg $VERSION.Risk.par 1 \
  -taskreg $VERSION.Reward.par 1 \
  -nuisreg $VERSION.mc.par -1 \
  -tpexclude $VERSION.censor.$FD.par \
  -hpf 0.01 \
  -nskip 4 \
  -spmhrf 0 \
  -TR $TR \
  -fsd $fsd \
  -per-run \
  -b0dc  \
  -analysis $VERSION.$FWHM.$FD.$SPACE \
  -force

end

mkanalysis-sess \
  -mni305 2 \
  -fwhm $FWHM \
  -notask \
  -taskreg $VERSION.Delib.par 1 \
  -taskreg $VERSION.DelibMod.par 1 \
  -taskreg $VERSION.FixedEpochs.par 1 \
  -taskreg $VERSION.Risk.par 1 \
  -taskreg $VERSION.Reward.par 1 \
  -nuisreg $VERSION.mc.par -1 \
  -tpexclude $VERSION.censor.$FD.par \
  -hpf 0.01 \
  -nskip 4 \
  -spmhrf 0 \
  -TR $TR \
  -fsd $fsd \
  -per-run \
  -b0dc  \
  -analysis $VERSION.$FWHM.$FD.mni305 \
  -force

end

cd $HOME_DIR
