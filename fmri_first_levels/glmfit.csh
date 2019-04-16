#!/bin/csh

## Configure an Analysis
set VERSION = Version20190405
set ROOT_DIR = /autofs/space/lilli_002/users/JNeurosci_ARC/fmri_first_levels/concat-sess/$VERSION
set CONTRASTS = (Delib DelibMod FixedEpochs Risk Reward)

foreach CONTRAST ($CONTRASTS)

  foreach SPACE (lh rh)

      set DATA_DIR = $ROOT_DIR/$VERSION.6.0.9.$SPACE/$VERSION.$CONTRAST.par

      mri_glmfit \
        --y $DATA_DIR/ces.nii.gz \
        --wls $DATA_DIR/cesvar.nii.gz \
        --osgm \
        --surface fsaverage $SPACE \
        --glmdir $DATA_DIR/WLS \
        --mgz

  end    


  set DATA_DIR = $ROOT_DIR/$VERSION.6.0.9.mni305/$VERSION.$CONTRAST.par

  mri_glmfit \
    --y $DATA_DIR/ces.nii.gz \
    --wls $DATA_DIR/cesvar.nii.gz \
    --osgm \
    --glmdir $DATA_DIR/WLS \
    --mgz

end

