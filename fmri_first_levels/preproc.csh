#!/bin/csh

#Configure an Analysis
set HOME_DIR = `pwd`
set VERSION = `cat {$HOME_DIR}/../params/VERSION.txt`
set ROOT_DIR  = `cat {$HOME_DIR}/../params/ROOT_DIR.txt`
set MRI_DIR  = `cat {$HOME_DIR}/../params/MRI_DIR.txt`
set BEHAVIOR_DIR = `cat {$HOME_DIR}/../params/BEHAVIOR_DIR.txt`
set SESSION = `cat {$HOME_DIR}/../params/SESSION.txt`
set SESSION_SHORT = `cat {$HOME_DIR}/../params/SESSION_SHORT.txt`
set SPACES = ( `cat {$HOME_DIR}/../params/SPACES.txt` )
set FWHM = `cat {$HOME_DIR}/../params/FWHM.txt`
set MODELS = ( `cat {$HOME_DIR}/../params/MODELS.txt` )
set FS_SOURCE_DIR = `cat {$HOME_DIR}/../params/FS_SOURCE_DIR.txt`
set SUBJECTS_DIR = `cat {$HOME_DIR}/../params/SUBJECTS_DIR.txt`
set TR_MS = `cat {$HOME_DIR}/../params/TR_MS.txt`
set TASK = `cat {$HOME_DIR}/../params/TASK.txt`
set MODALITY = `cat {$HOME_DIR}/../params/MODALITY.txt`
set PARADIGM = `cat {$HOME_DIR}/../params/PARADIGM.txt`

foreach THIS_DIR ( $ROOT_DIR $MRI_DIR $BEHAVIOR_DIR $SUBJECTS_DIR )
  mkdir -p THIS_DIR
end

## Call Freesurfer.
source $FS_SOURCE_DIR

setenv SUBJECTS_DIR $SUBJECTS_DIR

## Specify parameters.
set SUBJECTS = ( `tail -n +2 $MRI_DIR/participants.tsv` )

echo $SUBJECTS >> $ROOT_DIR/sessid

cd $ROOT_DIR

foreach SUBJECT ($SUBJECTS)

  setenv SUBJECT SUBJECT

  ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
  ## Copy behavior
  ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###

  set TASK_UPPER = ` echo $TASK | tr "[a-z]" "[A-Z]" `
  cp $MRI_DIR/sub-{$SUBJECT}/func/sub-{$SUBJECT}_task-{$TASK_UPPER}_events.tsv $BEHAVIOR_DIR/{$SUBJECT}_{$TASK}_{$MODALITY}-{$SESSION_SHORT}

  ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
  ## Run source reconstruction
  ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###

  recon-all -subjid $SUBJECT -i $MRI_DIR/sub-{$SUBJECT}/anat/sub-{$SUBJECT}_T1w.nii.gz --all

  ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
  ## Set Task Directory and TR. 
  ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###

  cd $ROOT_DIR
  set SUB_NAME = `echo $SUBJECT | tr '[:lower:]' '[:upper:]'`
  
  set SRC = $MRI_DIR/sub-{$SUBJECT}/anat/sub-{$SUBJECT}/sub-{$SUBJECT}_task-{$TASK_NAME}_bold.nii.gz
  set DST = $MRI_DIR/$SUBJECT/{$TASK}_{$SESSION}/$SESSION/f.nii
  if (-f SRC) then
    if (-f DST) then
        echo 'Functional file already renamed to f.nii.'
    else
        cp $SRC $DST
	echo 'Functional file copied to destination.'
    endif
  else
    echo $SRC
    echo 'Function file not found'
  endif

  set INFO = `mri_info $DST --tr`
  if !($INFO == $TR_MS) then
    mri_convert $DST $DST -tr $TR_MS
    #sleep 30
  else
    echo 'TR matches for ' $DST
  endif

  ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
  ## Beta-zero correction. 
  ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###

  if ( -f $MRI_DIR/$SUBJECT/{$TASK}_{$SESSION}/b0dcmap.nii.gz ) then 
    echo 'Beta-zero correction already performed.'
  else
    ## Source FSL 4.1.10.
    source /usr/local/freesurfer/nmr-stable53-env
    set FSL_DIR = /usr/pubsw/packages/fsl/4.1.10/
    source /usr/local/freesurfer/nmr-stable53-env
    
    set SESSION_DIR = $MRI_DIR/$SUBJECT/{$TASK}_{$SESSION}/$SESSION
    epidewarp.fsl --mag $SESSION_DIR/mag.nii --dph $SESSION_DIR/phase.nii --epi $SESSION_DIR/f.nii --tediff 2.46 --esp 0.69 --vsm $MRI_DIR/$SUBJECT/{$TASK}_{$SESSION}/b0dcmap.nii.gz

  endif

end

cd $HOME_DIR
