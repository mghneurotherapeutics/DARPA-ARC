#!/bin/csh

set CONTRASTS = (Delib DelibMod FixedEpochs Risk Reward)
set SPACES = (mni305 lh rh)
set PERM = ( `cat /autofs/space/lilli_002/users/JNeurosci_ARC/fmri_second_levels/permutations.txt`)

source /usr/local/freesurfer/nmr-stable53-env

foreach CONTRAST ($CONTRASTS)

  foreach SPACE ($SPACES)

    foreach P ($PERM)

        pbsubmit -m arockhill@mgh.harvard.edu -c "python wls_perm.py $SPACE $CONTRAST $P"

    end

  end

end
