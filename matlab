edit(fullfile(userpath,'startup.m'))



fsldir = '\\wsl$\Ubuntu\home\davgob\fsl';

if isfolder(fsldir)
    fsl_matlab_path = fullfile(fsldir, 'etc', 'matlab');
    addpath(fsl_matlab_path);
    fprintf('FSL Path added automatically from startup.m\n');
end
