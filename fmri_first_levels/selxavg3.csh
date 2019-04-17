#!/bin/csh

set HOME_DIR = `pwd`
set ROOT_DIR = `cat {$HOME_DIR}/../params/ROOT_DIR.txt`
set FWHM = `cat {$HOME_DIR}/../params/FWHM.txt`
set TASK = `cat {$HOME_DIR}/../params/TASK.txt`
set VERSION = `cat {$HOME_DIR}/../params/VERSION.txt`
set SUBJECTS = ( `cat $ROOT_DIR/scripts/sessid` )
set SPACES = ( `cat {$HOME_DIR}/../params/SPACES.txt` )
set THRESHOLDS = ( `cat {$HOME_DIR}/../params/THRESHOLDS.txt` )
set MODELS = ( `cat {$HOME_DIR}/../params/MODELS.txt` )

cd $ROOT_DIR

foreach MODEL ($MODELS)
foreach SUBJECT ($SUBJECTS)
foreach SPACE ($SPACES)
foreach FD ($THRESHOLDS)

selxavg3-sess -s $SUBJECT -analysis $VERSION.$TASK.$MODEL.$FWHM.$FD.$SPACE -no-preproc -overwrite

end
end
end
end

cd $HOME_DIR
