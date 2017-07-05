function multiband_slice_timing( )
% This is a simple wrapper function that does slice timing corrections for
% the Deckersbach group for their multi-band imaging scans. Assumes a scan
% with 63 slices collected in an interleaved fashion (odds-first) across
% three volumes.

%% Select nii file.
dir = ['/space/lilli/2/users/DARPA-FAST/'];
P = spm_select(Inf,'image',[],[],dir,'.nii','1:1000');

%% Cue for TR.
TR = inputdlg('TR:','Please enter TR...');
TR = str2double(TR);

%% Define parameters.
% Define slice orders.
sliceorder = [1:2:21 2:2:21; 22:2:42 23:2:42; 43:2:63 44:2:63]';

% Define reference slice.
refslice = 1;

% Timing
nSlices = 21;
TA = TR - (TR/nSlices);
timing(1) = TA / (nSlices - 1);
timing(2) = TR - TA;

% Prefix
prefix = 'a';

%% Perform slice timing.
spm_mbst(P, sliceorder, refslice, timing, prefix);

end

