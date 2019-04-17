#!/bin/csh

set HOME_DIR = `pwd`
set ROOT_DIR = `cat {$HOME_DIR}/../params/ROOT_DIR.txt`
set SPACES = ( `cat {$HOME_DIR}/../params/SPACES.txt` )
set MODEL_NAMES = ( `cat {$HOME_DIR}/../params/MODEL_NAMES.txt` )
set CONDITIONS = ( `cat {$HOME_DIR}/../params/CONDITIONS.txt` )
set PERM = ( `cat $ROOT_DIR/fmri_second_levels/permutations.txt`)

source /usr/local/freesurfer/nmr-stable53-env

foreach MODEL_NAME ($MODEL_NAMES)

  foreach CONTRAST ($CONTRASTS)

    foreach SPACE ($SPACES)

      foreach P ($PERM)

          pbsubmit -m arockhill@mgh.harvard.edu -c "python wls_perm.py $MODEL_NAME $SPACE $CONTRAST $P"

      end

   end

  end

end
