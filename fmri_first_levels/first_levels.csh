#!/bin/csh

set HOME_DIR=`pwd`
set ROOT_DIR = `cat {$HOME_DIR}/../params/ROOT_DIR.txt`
set MY_VERSION = `cat {$HOME_DIR}/../params/VERSION.txt`
set FWHM = `cat {$HOME_DIR}/../params/FWHM.txt`
set TASK = `cat {$HOME_DIR}/../params/TASK.txt`
set TR = `cat {$HOME_DIR}/../params/TR.txt`
set SESSID = $ROOT_DIR/fmri_first_levels/scripts/sessid
set OUT_DIR = $ROOT_DIR/fmri_first_levels/concat-sess/$MY_VERSION
set SUBJECTS = ( `cat $ROOT_DIR/fmri_first_levels/sessid` )
set SPACES = ( `cat {$HOME_DIR}/../params/SPACES.txt` )
set FS_SOURCE_DIR = `cat {$HOME_DIR}/../params/FS_SOURCE_DIR.txt`


if ( $#argv == 1 ) then
  if ( "$1" == "-check_threshs" ) then
    set THRESHOLDS = ( `cat {$HOME_DIR}/../params/THRESHOLDS.txt` )
    set MODELS = ( `head -1 {$HOME_DIR}/../params/MODELS.txt` )
  else
    echo "Command not recognized $1"
    exit(1)
  endif
else if ( $#argv == 0 ) then
  set THRESHOLDS = ( `cat {$HOME_DIR}/../params/FD.txt` )
  set MODELS = ( `cat {$HOME_DIR}/../params/MODELS.txt` )
else
  echo "Commands not recognized $argv"
  exit(1)
endif

source $FS_SOURCE_DIR

cd $ROOT_DIR/fmri_first_levels

mkdir -p mkanalysis-sess

foreach MODEL ($MODELS)
set REGRESSOR_TEXT = `cat {$HOME_DIR}/../params/$MODEL.REGRESSOR_TEXT.txt`
set REGRESSORS = `cat {$HOME_DIR}/../params/$MODEL.REGRESSORS.txt`
foreach FD ($THRESHOLDS)
foreach SPACE ( lh rh )

mkanalysis-sess \
  -surface fsaverage $SPACE \
  -fwhm $FWHM \
  -notask \
  $REGRESSOR_TEXT \
  -nuisreg $MY_VERSION.mc.par -1 \
  -tpexclude $MY_VERSION.censor.$FD.par \
  -hpf 0.01 \
  -nskip 4 \
  -spmhrf 0 \
  -TR $TR \
  -fsd {$TASK}_001 \
  -per-run \
  -b0dc  \
  -analysis $MY_VERSION.$TASK.$MODEL.$FWHM.$FD.$SPACE \
  -force

end

mkanalysis-sess \
  -mni305 2 \
  -fwhm $FWHM \
  -notask \
  $REGRESSOR_TEXT \
  -nuisreg $MY_VERSION.mc.par -1 \
  -tpexclude $MY_VERSION.censor.$FD.par \
  -hpf 0.01 \
  -nskip 4 \
  -spmhrf 0 \
  -TR $TR \
  -fsd {$TASK}_001 \
  -per-run \
  -b0dc  \
  -analysis $MY_VERSION.$TASK.$MODEL.$FWHM.$FD.mni305 \
  -force

foreach SUBJECT ($SUBJECTS)
foreach SPACE ($SPACES)

selxavg3-sess -s $SUBJECT -analysis $MY_VERSION.$TASK.$MODEL.$FWHM.$FD.$SPACE -no-preproc -overwrite

end
end

foreach SPACE ($SPACES)

isxconcat-sess -sf $SESSID -analysis $MY_VERSION.$TASK.$MODEL.$FWHM.$FD.$SPACE -all-contrasts -o $OUT_DIR
mv $MY_VERSION.$TASK.$MODEL.$FWHM.$FD.$SPACE mkanalysis-sess/$MY_VERSION.$TASK.$MODEL.$FWHM.$FD.$SPACE

end

foreach REGRESSOR ($REGRESSORS)
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
end
end

cd $HOME_DIR
