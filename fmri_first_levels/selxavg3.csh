#!/bin/csh

set ROOT_DIR = /autofs/space/lilli_002/users/JNeurosci_ARC/fmri_first_levels
set HOME_DIR = `pwd`
set VERSION = Version20190405
set SUBJECTS = ( `cat $ROOT_DIR/scripts/sessid` )
set SPACES = ( lh rh mni305 )
set FD = ( 0.0 0.5 0.7 0.9 1.1 1.3 )

cd $ROOT_DIR

foreach SUBJECT ($SUBJECTS)
foreach SPACE ($SPACES)
foreach fd ($FD)

selxavg3-sess -s $SUBJECT -analysis $VERSION.6.$fd.$SPACE -no-preproc -overwrite

end
end
end

cd $HOME_DIR
