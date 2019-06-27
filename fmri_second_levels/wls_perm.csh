#!/bin/csh

set HOME_DIR = `pwd`
set ROOT_DIR = `cat {$HOME_DIR}/../params/ROOT_DIR.txt`
set SPACES = ( `cat {$HOME_DIR}/../params/SPACES.txt` )
set MODELS = ( `cat {$HOME_DIR}/../params/MODELS.txt` )
set PERM = ( `cat $ROOT_DIR/fmri_second_levels/permutations.txt`)

source /usr/local/freesurfer/nmr-stable53-env

foreach MODEL ($MODELS)

  set REGRESSORS = `cat {$HOME_DIR}/../params/$MODEL.REGRESSORS.txt`

  foreach REGRESSOR ($REGRESSORS)

    foreach SPACE ($SPACES)

      foreach P ($PERM)

          pbsubmit -m arockhill@mgh.harvard.edu -c "python wls_perm.py $SPACE $REGRESSOR $P 0" # -q max500

      end

   end

  end

end
