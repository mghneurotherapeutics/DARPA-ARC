#!/bin/csh

## Configure an Analysis
set HOME_DIR = `pwd`
set TASK = `cat {$HOME_DIR}/../params/TASK.txt`
set MY_VERSION = `cat {$HOME_DIR}/../params/VERSION.txt`
set ROOT_DIR = `cat {$HOME_DIR}/../params/ROOT_DIR.txt`
set CONCAT_SESS_DIR = $ROOT_DIR/fmri_first_levels/concat-sess/$VERSION
set MODELS = ( `cat {$HOME_DIR}/../params/MODELS.txt` )
set FWHM = `cat {$HOME_DIR}/../params/FWHM.txt`
set FD = `cat {$HOME_DIR}/../params/FD.txt`

foreach MODEL ($MODELS)

  set REGRESSORS = `cat {$HOME_DIR}/../params/$MODEL.REGRESSORS.txt`

  foreach SPACE (lh rh)

      set DATA_DIR = $ROOT_DIR/fmri_first_levels/concat-sess/$MY_VERSION/$MY_VERSION.$TASK.$MODEL.$FWHM.$FD.$SPACE/$REGRESSOR

      mri_glmfit \
        --y $DATA_DIR/ces.nii.gz \
        --wls $DATA_DIR/cesvar.nii.gz \
        --osgm \
        --surface fsaverage $SPACE \
        --glmdir $DATA_DIR/WLS \
        --mgz

  end    


  set DATA_DIR = $ROOT_DIR/fmri_first_levels/concat-sess/$MY_VERSION/$MY_VERSION.$TASK.$MODEL.$FWHM.$FD.mni305/$REGRESSOR

  mri_glmfit \
    --y $DATA_DIR/ces.nii.gz \
    --wls $DATA_DIR/cesvar.nii.gz \
    --osgm \
    --glmdir $DATA_DIR/WLS \
    --mgz

end

