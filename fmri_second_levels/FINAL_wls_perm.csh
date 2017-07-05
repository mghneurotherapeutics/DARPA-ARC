set CONTRASTS = (Delib DelibMod Antcp AntcpMod Shock)
set SPACES = (mni305 lh rh)
set PERM = (`cat permutations.txt`)

foreach CONTRAST ($CONTRASTS)

  foreach SPACE ($SPACES)

    foreach P ($PERM)

        pbsubmit -m szorowi1@gmail.com -c "python FINAL_wls_perm.py $SPACE $CONTRAST $P"

    end

  end

end
