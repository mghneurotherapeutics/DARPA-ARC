import sys
sys.path.append('..')
from my_settings import (os, op, np, version, read_csv, root_dir,
                         sm, fd, X, n_subj, n_pred, prepare_image,
                         load_sparse_coo, wls, task, models,
                         conditions_dict, spaces, n_permutations,
                         inc)

permutations = np.arange(n_permutations/inc) + 1

grand_no_file_sum = 0

for model_name, analysis, epochs_type in models:
    #
    for condition in ['Control'] + conditions_dict[analysis]:
        #
        for n, space in enumerate(spaces):
            #
            no_file_sum = 0
            #
            out_dir = op.join(root_dir, 'fmri_second_levels', ('%s.%s.%s.%s.%s.%s.%s.%s.%s' % 
                                                               (version, task, model_name, 
                                                                analysis, epochs_type,
                                                                sm, fd, space, condition)))
            #
            obs_f = op.join(out_dir, ('%s.%s.%s.%s.%s.%s.%s.%s.%s_obs.npz' % 
                                      (version, task, model_name, analysis,
                                       epochs_type, sm, fd, space, condition)))
            #
            if not op.isfile(obs_f):
            	no_file_sum += 1
            #
            perm_f = op.join(out_dir, ('%s.%s.%s.%s.%s.%s.%s.%s.%s' %
                                       (version, task, model_name, analysis,
                                        epochs_type, sm, fd, space, condition)) + 
                                       '_perm-%s.npz')
            for p in permutations:
            	if not op.isfile(perm_f % int(p)):
            		no_file_sum += 1
            grand_no_file_sum += no_file_sum
            print(model_name, analysis, epochs_type, condition, space, no_file_sum)
print('Total', grand_no_file_sum)