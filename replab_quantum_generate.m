function result = replab_quantum_generate(what)
% Website generation function
%
% This function should not be called before'replab_init' has been called at
% least once.
%
% Depending on the value of the argument ``what``:
%
% - ``all`` same as ``sphinx``
%
% - ``clear`` clears out all directories with autogenerated code/doc
%
% - ``sphinxsrc`` prepares a source folder on which to run Sphinx
%
% - ``sphinxbuild`` runs the Sphinx documentation generation.
%
% - ``sphinx`` runs all the Sphinx generation steps.
%
% Args:
%   what ({'clear', 'sphinx*', 'sphinx', 'all'}, optional): What to generate, default ``'all'``
%
% Results:
%     logical: True unless an error was detected

    if nargin < 1
        what = 'all';
    end
    
    result = true;
    
    % Obtain repository path
    [pathStr, name, extension] = fileparts(which(mfilename));
    pathStr = strrep(pathStr, '\', '/');

    logFun = @(str) disp(str);
    valid = {'clear' 'sphinxsrc' 'sphinxbuild' 'sphinx' 'all'};
    validStr = strjoin(cellfun(@(x) sprintf('''%s''', x), valid, 'uniform', 0), ', ');
    assert(ismember(what, valid), 'Argument must be one of: %s', validStr);

    % Check replab relative location
    rp = replab.globals.replabPath;
    if (length(rp) < length(pathStr)) || ~isequal(pathStr, rp(1:length(pathStr)))
        warning('Using a different version of RepLAB than the one contained in the ''external/replab'' subfolder. To avoid version mismatches, remove RepLAB from the path and re-initialize the library in the correct subfolder.');
    end

    sphinxRoot = fullfile(pathStr, 'sphinx');
    sphinxPreprocessed = fullfile(pathStr, '_sphinx');
    if isequal(what, 'sphinxsrc') || isequal(what, 'sphinx') || isequal(what, 'all') || isequal(what, 'clear')
        if isequal(what, 'clear')
            replab.infra.mkCleanDir(pathStr, '_sphinx', logFun);
        else
            % Create a copy of the Sphinx source folder and update the
            % matlab doc links
            replab_generate_sphinxsrc_docpp(sphinxRoot, sphinxPreprocessed, 'https://replab.github.io/replab');
        end
    end
    
    if isequal(what, 'sphinxbuild') || isequal(what, 'sphinx') || isequal(what, 'all')
        sphinxTarget = fullfile(pathStr, 'docs');
        if ~exist(sphinxTarget, 'dir')
            mkdir(sphinxTarget);
        end
        replab.infra.cleanDir(sphinxTarget, {'.git'});
        if ~isequal(what, 'clear')
            % Launch sphinx
            logFun('Running Sphinx');
            cmd = ['sphinx-build -b html ', sphinxPreprocessed, ' ', sphinxTarget];
            logFun(['Running ' cmd]);
            status = system(cmd);
            if status ~= 0
                result = false;
            end
        end
    end
end
