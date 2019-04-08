#!/bin/csh

## Configure an Analysis
set version = Version20190405
set ROOT_DIR = /autofs/space/karima_001/users/DARPA-ARC/$version
set CONTRASTS = (Delib DelibMod Risk Reward)

foreach CONTRAST ($CONTRASTS)

  foreach SPACE (lh rh)

      set DATA_DIR = $ROOT_DIR/$version.6.0.9.$SPACE/$version.$CONTRAST.par

      mri_glmfit \
        --y $DATA_DIR/ces.nii.gz \
        --wls $DATA_DIR/cesvar.nii.gz \
        --osgm \
        --surface fsaverage $SPACE \
        --glmdir $DATA_DIR/WLS \
        --mgz

  end    


  set DATA_DIR = $ROOT_DIR/$version.6.0.9.mni305/$version.$CONTRAST.par

  mri_glmfit \
    --y $DATA_DIR/ces.nii.gz \
    --wls $DATA_DIR/cesvar.nii.gz \
    --osgm \
    --glmdir $DATA_DIR/WLS \
    --mgz

end

