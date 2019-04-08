#!/bin/csh

## Source Freesufer.
source /usr/local/freesurfer/nmr-stable53-env
setenv SUBJECTS_DIR /autofs/space/lilli_001/users/DARPA-Recons/
set ROOT_DIR = /autofs/space/lilli_002/users/DARPA-ARC
set SCRIPTS_DIR = $ROOT_DIR/scripts

## Specify parameters.
set SUBJECTS = (hc002)
set FWHM = 6
set TR = 1750

cd $ROOT_DIR

foreach SUBJECT ($SUBJECTS)

  ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
  ## Convert f.nii
  ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
  set FN = $ROOT_DIR/$SUBJECT/arc_001/001/f.nii
  set INFO = `mri_info $FN --tr`
  if !($INFO == $TR) then
    mri_convert $FN $FN -tr $TR
    #sleep 30
  else
    echo 'Good news, eveyrone! The TR matches.' 
  endif

  ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
  ## Beta-zero correction. 
  ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###

  if ( -f $ROOT_DIR/$SUBJECT/arc_001/b0dcmap.nii.gz ) then
    echo 'Beta-zero corrected.'
  else
    ## Source FSL 4.1.10.
    source /usr/local/freesurfer/nmr-stable53-env
    set FSL_DIR = /usr/pubsw/packages/fsl/4.1.10/
    source /usr/local/freesurfer/nmr-stable53-env

    epidewarp.fsl --mag $ROOT_DIR/$SUBJECT/{$TASK}/001/mag.nii --dph $ROOT_DIR/$SUBJECT/{$TASK}/001/phase.nii --epi $ROOT_DIR/$SUBJECT/{$TASK}/001/f.nii --tediff 2.46 --esp 0.69 --vsm $ROOT_DIR/$SUBJECT/{$TASK}/b0dcmap.nii.gz
  endif

  ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
  ## Preprocess. 
  ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###

  ## Source current version of FSL. 
  set FSL_DIR = /usr/pubsw/packages/fsl/current
  preproc-sess -s $SUBJECT -surface fsaverage lhrh -mni305 -fwhm $FWHM -per-run -fsd arc_001 -nostc -b0dc -force

end

cd $SCRIPTS_DIR
