set FWHM = 6
set TR = 1.75
set FDs = (0.0 0.5 0.7 0.9 1.1 1.3)
set fsd = arc_001

cd /autofs/space/lilli_002/users/DARPA-ARC/

foreach FD ($FDs)
foreach SPACE (lh rh)

mkanalysis-sess \
  -surface fsaverage $SPACE \
  -fwhm $FWHM \
  -notask \
  -taskreg FINAL.Delib.par 1 \
  -taskreg FINAL.DelibMod.par 1 \
  -taskreg FINAL.Antcp.par 1 \
  -taskreg FINAL.AntcpMod.par 1 \
  -taskreg FINAL.Shock.par 1 \
  -nuisreg FINAL.mc.par -1 \
  -tpexclude FINAL.censor.$FD.par \
  -hpf 0.02 \
  -nskip 4 \
  -spmhrf 0 \
  -TR $TR \
  -fsd $fsd \
  -per-run \
  -b0dc  \
  -analysis FINAL.$FWHM.$FD.$SPACE

end

mkanalysis-sess \
  -mni305 2 \
  -fwhm $FWHM \
  -notask \
  -taskreg FINAL.Delib.par 1 \
  -taskreg FINAL.DelibMod.par 1 \
  -taskreg FINAL.Antcp.par 1 \
  -taskreg FINAL.AntcpMod.par 1 \
  -taskreg FINAL.Shock.par 1 \
  -nuisreg FINAL.mc.par -1 \
  -tpexclude FINAL.censor.$FD.par \
  -hpf 0.02 \
  -nskip 4 \
  -spmhrf 0 \
  -TR $TR \
  -fsd $fsd \
  -per-run \
  -b0dc  \
  -analysis FINAL.$FWHM.$FD.mni305

end

cd /autofs/space/lilli_002/users/DARPA-ARC/NN_bayes_2016/scripts
