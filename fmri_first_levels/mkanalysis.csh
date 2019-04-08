#!/bin/csh

set FWHM = 6
set TR = 1.75
set FDs = (0.0 0.5 0.7 0.9 1.1 1.3)
set fsd = arc_001
set version = Version20190405
set HOME_DIR = `pwd`

cd /autofs/space/karima_001/users/JNeurosci_ARC/fmri_first_levels

foreach FD ($FDs)
foreach SPACE (lh rh)

mkanalysis-sess \
  -surface fsaverage $SPACE \
  -fwhm $FWHM \
  -notask \
  -taskreg $version.Delib.par 1 \
  -taskreg $version.DelibMod.par 1 \
  -taskreg $version.Risk.par 1 \
  -taskreg $version.Reward.par 1 \
  -nuisreg $version.mc.par -1 \
  -tpexclude $version.censor.$FD.par \
  -hpf 0.01 \
  -nskip 4 \
  -spmhrf 0 \
  -TR $TR \
  -fsd $fsd \
  -per-run \
  -b0dc  \
  -analysis $version.$FWHM.$FD.$SPACE

end

mkanalysis-sess \
  -mni305 2 \
  -fwhm $FWHM \
  -notask \
  -taskreg $version.Delib.par 1 \
  -taskreg $version.DelibMod.par 1 \
  -taskreg $version.Risk.par 1 \
  -taskreg $version.Reward.par 1 \
  -nuisreg $version.mc.par -1 \
  -tpexclude $version.censor.$FD.par \
  -hpf 0.01 \
  -nskip 4 \
  -spmhrf 0 \
  -TR $TR \
  -fsd $fsd \
  -per-run \
  -b0dc  \
  -analysis $version.$FWHM.$FD.mni305

end

cd $HOME_DIR
