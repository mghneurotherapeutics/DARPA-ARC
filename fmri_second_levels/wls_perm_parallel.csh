#!/bin/csh

set HOME_DIR = `pwd`
set ROOT_DIR = `cat {$HOME_DIR}/../params/ROOT_DIR.txt`
set SPACES = ( `cat {$HOME_DIR}/../params/SPACES.txt` )
set MODELS = ( `cat {$HOME_DIR}/../params/MODELS.txt` )
set PERM = ( `cat $ROOT_DIR/fmri_second_levels/permutations.txt`)

@ i = 1

source /usr/local/freesurfer/nmr-stable53-env

foreach MODEL ($MODELS)

  set REGRESSORS = `cat {$HOME_DIR}/../params/$MODEL.REGRESSORS.txt`

  foreach REGRESSOR ($REGRESSORS)

    foreach SPACE ($SPACES)

      foreach P ($PERM)

          python wls_perm.py $SPACE $REGRESSOR $P 0 &

          @ i += 1

          echo $i

          if ( $i == ( `nproc` - 4)) then
              
              wait
              @ i = 1

          endif

      end

   end

  end

end
