function result = replab_quantum_generate(what)
% Code generation function
%
% This function should not be called before'replab_init' has been called at
% least once.
%
% Depending on the value of the argument ``what``:
%
% - ``all`` regenerates all generated code/documentation
%
% - ``clear`` clears out all directories with autogenerated code/doc
%
% - ``sphinx`` runs all the Sphinx generation steps.
%
% Args:
%   what ({'clear', 'sphinx', 'all'}, optional): What to generate, default ``'all'``
%
% Results:
%     logical: True unless an error was detected

    if nargin < 1
        what = 'all';
    end
    
    result = true;
    
    % Make sure we are in the correct path
    initialPath = pwd;
    [pathStr, name, extension] = fileparts(which(mfilename));
    pathStr = strrep(pathStr, '\', '/');
    cd(pathStr)

    logFun = @(str) disp(str);
    valid = {'clear' 'sphinx' 'sphinxbuild' 'sphinxsrc' 'all'};
    validStr = strjoin(cellfun(@(x) sprintf('''%s''', x), valid, 'uniform', 0), ', ');
    assert(ismember(what, valid), 'Argument must be one of: %s', validStr);

    % Get the replab folder
    rp = replab.globals.replabPath;
    if (length(rp) < length(pathStr)) || ~isequal(pathStr, rp(1:length(pathStr)))
        warning('Using a different version of RepLAB than the one contained in the ''external/replab'' subfolder. To avoid version mismatches, remove RepLAB from the path and re-initialize the library in the correct subfolder.');
    end
    srcRoot = fullfile(rp, 'src');

    if isequal(what, 'sphinx') || isequal(what, 'all') || isequal(what, 'clear')
        if ~exist(fullfile(pathStr, 'docs'))
            mkdir(pathStr, 'docs');
        end
        replab.infra.cleanDir(fullfile(pathStr, 'docs'), {'.git'});
        if ~isequal(what, 'clear')
            disp('Running Sphinx');
            lastPath = pwd;
            cd(pathStr);
            cmd = 'sphinx-build -b html sphinx docs';
            disp(['Running ' cmd]);
            status = system(cmd);
            if status ~= 0
                result = false;
            end
            cd(lastPath);
        end
    end

    % return to the previous path
    cd(initialPath);
end
