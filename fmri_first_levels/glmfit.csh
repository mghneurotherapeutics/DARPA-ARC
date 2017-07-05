## Configure an Analysis
set ROOT_DIR = /autofs/space/lilli_002/users/DARPA-ARC/NN_bayes_2016/FINAL6
set CONTRASTS = (Delib DelibMod)

foreach CONTRAST ($CONTRASTS)

  foreach SPACE (lh rh)

      set DATA_DIR = $ROOT_DIR/FINAL.6.0.9.$SPACE/FINAL.$CONTRAST.par

      mri_glmfit \
        --y $DATA_DIR/ces.nii.gz \
        --wls $DATA_DIR/cesvar.nii.gz \
        --osgm \
        --surface fsaverage $SPACE \
        --glmdir $DATA_DIR/WLS \
        --mgz

  end    


  set DATA_DIR = $ROOT_DIR/FINAL.6.0.9.mni305/FINAL.$CONTRAST.par

  mri_glmfit \
    --y $DATA_DIR/ces.nii.gz \
    --wls $DATA_DIR/cesvar.nii.gz \
    --osgm \
    --glmdir $DATA_DIR/WLS \
    --mgz

end

