set SUBJECTS = (hc001 hc002 hc004 hc005 hc006 hc007 hc008 hc009 hc010 hc011 hc013 hc015 hc017 hc019 hc021 hc022 hc023 hc025 hc026 hc027 hc028 hc029)
set SUBJECTS = (hc030 hc031 hc032 hc033 hc034 hc036)

set MRI_DIR = /autofs/space/lilli_002/users/DARPA-ARC

## Call Freesurfer
fs

foreach SUBJECT ($SUBJECTS)

  ## Define files.
  set TEMPLATE = $MRI_DIR/$SUBJECT/arc_001/template.nii.gz
  set REG =  $MRI_DIR/$SUBJECT/arc_001/001/masks/$SUBJECT.arc.reg.dat
  set OUT = $MRI_DIR/$SUBJECT/arc_001/001/masks/wm.mgz

  ## Co-register subject's native space to EPI image.
  bbregister --s $SUBJECT --mov $TEMPLATE --reg $REG --init-fsl --bold

  ## Warp white matter mask to EPI space.
  mri_vol2vol --mov $TEMPLATE --targ $SUBJECTS_DIR/$SUBJECT/mri/wm.mgz --reg $REG --o $OUT --nearest --inv

end
