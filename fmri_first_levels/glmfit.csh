#!/bin/csh

## Configure an Analysis
set HOME_DIR = `pwd`
set TASK = `cat {$HOME_DIR}/../params/TASK.txt`
set VERSION = `cat {$HOME_DIR}/../params/VERSION.txt`
set ROOT_DIR = `cat {$HOME_DIR}/../params/ROOT_DIR.txt`
set CONCAT_SESS_DIR = $ROOT_DIR/fmri_first_levels/concat-sess/$VERSION
set CONDITIONS = ( `cat {$HOME_DIR}/../params/CONDITIONS.txt` )
set FWHM = `cat {$HOME_DIR}/../params/FWHM.txt`
set FD = `cat {$HOME_DIR}/../params/FD.txt`

foreach CONDITION ($CONDITIONS)

  foreach SPACE (lh rh)

      set DATA_DIR = $ROOT_DIR/$TASK.$MODEL.$VERSION.$FWHM.$FD.$SPACE/$TASK.$MODEL.$VERSION.$CONDITION.par

      mri_glmfit \
        --y $DATA_DIR/ces.nii.gz \
        --wls $DATA_DIR/cesvar.nii.gz \
        --osgm \
        --surface fsaverage $SPACE \
        --glmdir $DATA_DIR/WLS \
        --mgz

  end    


  set DATA_DIR = $ROOT_DIR/$TASK.$MODEL.$VERSION.$FWHM.$FD.mni305/$TASK.$MODEL.$VERSION.$CONDITION.par

  mri_glmfit \
    --y $DATA_DIR/ces.nii.gz \
    --wls $DATA_DIR/cesvar.nii.gz \
    --osgm \
    --glmdir $DATA_DIR/WLS \
    --mgz

end

