#!/bin/csh

set HOME_DIR = `pwd`
set ROOT_DIR = `cat {$HOME_DIR}/../params/ROOT_DIR.txt`
set FWHM = `cat {$HOME_DIR}/../params/FWHM.txt`
set TASK = `cat {$HOME_DIR}/../params/TASK.txt`
set MY_VERSION = `cat {$HOME_DIR}/../params/VERSION.txt`
set SUBJECTS = ( `cat $ROOT_DIR/fmri_first_levels/sessid` )
set SPACES = ( `cat {$HOME_DIR}/../params/SPACES.txt` )
set MODELS = ( `cat {$HOME_DIR}/../params/MODELS.txt` )
set FS_SOURCE_DIR = `cat {$HOME_DIR}/../params/FS_SOURCE_DIR.txt`

if ("$1" == "-check_threshs") then
  set THRESHOLDS = ( `cat {$HOME_DIR}/../params/THRESHOLDS.txt` )
  set MODELS = ( `head -1 {$HOME_DIR}/../params/MODELS.txt` )
else
  set THRESHOLDS = ( `cat {$HOME_DIR}/../params/FD.txt` )
  set MODELS = ( `cat {$HOME_DIR}/../params/MODELS.txt` )
endif

source $FS_SOURCE_DIR

cd $ROOT_DIR/fmri_first_levels

foreach MODEL ( non-hierarchical.DelibMod.VariableEpochs ) #$MODELS)
foreach SUBJECT ($SUBJECTS)
foreach SPACE ( mni305 ) #$SPACES)
foreach FD ($THRESHOLDS)

selxavg3-sess -s $SUBJECT -analysis $MY_VERSION.$TASK.$MODEL.$FWHM.$FD.$SPACE -no-preproc -overwrite

end
end
end
end

cd $HOME_DIR
