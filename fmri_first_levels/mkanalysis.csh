set FWHM = 6
set TR = 1.75
set FDs = (0.0 0.5 0.7 0.9 1.1 1.3)
set fsd = arc_001

cd /autofs/space/lilli_002/users/JNeurosci_ARC/fmri_first_levels

foreach FD ($FDs)
foreach SPACE (lh rh)

mkanalysis-sess \
  -surface fsaverage $SPACE \
  -fwhm $FWHM \
  -notask \
  -taskreg FINAL2.Delib.par 1 \
  -taskreg FINAL2.DelibMod.par 1 \
  -taskreg FINAL2.Antcp.par 1 \
  -taskreg FINAL2.AntcpMod.par 1 \
  -taskreg FINAL2.Shock.par 1 \
  -nuisreg FINAL2.mc.par -1 \
  -tpexclude FINAL2.censor.$FD.par \
  -hpf 0.01 \
  -nskip 4 \
  -spmhrf 0 \
  -TR $TR \
  -fsd $fsd \
  -per-run \
  -b0dc  \
  -analysis FINAL2.$FWHM.$FD.$SPACE

end

mkanalysis-sess \
  -mni305 2 \
  -fwhm $FWHM \
  -notask \
  -taskreg FINAL2.Delib.par 1 \
  -taskreg FINAL2.DelibMod.par 1 \
  -taskreg FINAL2.Antcp.par 1 \
  -taskreg FINAL2.AntcpMod.par 1 \
  -taskreg FINAL2.Shock.par 1 \
  -nuisreg FINAL2.mc.par -1 \
  -tpexclude FINAL2.censor.$FD.par \
  -hpf 0.01 \
  -nskip 4 \
  -spmhrf 0 \
  -TR $TR \
  -fsd $fsd \
  -per-run \
  -b0dc  \
  -analysis FINAL2.$FWHM.$FD.mni305

end

cd /autofs/space/lilli_002/users/JNeurosci_ARC/fmri_first_levels/NN_bayes_2016/scripts
