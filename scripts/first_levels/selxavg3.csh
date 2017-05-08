set ROOT_DIR = /autofs/space/lilli_002/users/DARPA-ARC/
set SCRIPTS_DIR = $ROOT_DIR/NN_bayes_2016/scripts
set SUBJECTS = (`cat $SCRIPTS_DIR/sessid4`)
set SPACES = (lh rh mni305)
set FD = (0.0 0.5 0.7 0.9 1.1 1.3)

cd $ROOT_DIR

foreach SUBJECT ($SUBJECTS)
foreach SPACE ($SPACES)
foreach fd ($FD)

selxavg3-sess -s $SUBJECT -analysis FINAL.6.$fd.$SPACE -no-preproc -overwrite

end
end
end

cd $SCRIPTS_DIR
