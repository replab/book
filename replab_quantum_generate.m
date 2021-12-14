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
        if ~exist(fullfile(pathStr, '_sphinx'))
            mkdir(pathStr, '_sphinx');
        end
        replab.infra.cleanDir(fullfile(pathStr, '_sphinx'), {'.git'});
        if ~exist(fullfile(pathStr, 'docs'))
            mkdir(pathStr, 'docs');
        end
        replab.infra.cleanDir(fullfile(pathStr, 'docs'), {'.git'});
        if ~isequal(what, 'clear')
            % Create a modifiable copy of the sphinx folder
            copyfile(fullfile(pathStr, 'sphinx/*'), fullfile(pathStr, '_sphinx'));

            % Load the conversion table to create API links in matlab files
            baseWeb = 'https://replab.github.io/replab';
            if unix(['python3 -m sphinx.ext.intersphinx https://replab.github.io/replab/objects.inv > ', pathStr, '/_sphinx/API_links.txt'])
                warning('API conversion table not found, cross-links will not work in .m files');
            end
            
            % Select matlab files in the doc (excluding API) and compute
            % their links
            [status, fileList] = unix('find _sphinx -type f | grep -v ^"_sphinx/_src" | grep [.]m$');
            fileList = regexp(fileList, '\n', 'split');
            fileList = fileList(1:end-1);
            if status == 0
                pb = replab.infra.repl.ProgressBar(length(fileList));
                for i = 1:length(fileList)
                    pb.step(i, fileList{i});
                    content = replab.infra.CodeTokens.fromFile(fileList{i});
                    lines = content.lines;
                    lines = lines(find(cellfun(@(x) length(x), lines) ~= 0, 1, 'last'));
                    for j = find(content.tags == '%')
                        line = lines{j};
                        extents = regexp(line, '(`~?\+replab\.[\w,\.]+`|`~?root\.[\w,\.]+`)', 'tokenExtents');
                        extents{end+1} = length(line)+1;
                        if ~isempty(extents)
                            newLine = line(1:extents{1}(1)-1);
                            for k = 1:length(extents)-1
                                token = line(extents{k}(1)+1:extents{k}(2)-1);
                                silent = (token(1) == '~');
                                if silent
                                    tokenName = regexp(token, '\.*(\w+)$', 'tokens');
                                    tokenName = tokenName{1}{1};
                                    token = token(2:end);
                                else
                                    tokenName = token;
                                end
                                tokenName = tokenName(tokenName ~= '+');
                                [status, match] = unix(['cat ', pathStr, '/_sphinx/API_links.txt | grep "^[[:space:]]*', token, '\ "']);
                                if status == 0
                                    if length(regexp(match(1:end-1), '\n', 'split')) > 1
                                        warning(['Multiple references were found for ', token, ' in the API: ', match]);
                                    end
                                    link = regexp(match(1:end-1), '\ ([^\ ]+)$', 'tokens');
                                    link = [baseWeb, '/', link{1}{1}];
                                    newLine = [newLine, '[', tokenName, '](', link,')'];
                                else
                                    warning(['Reference ', token, ' was not found in the API.']);
                                    newLine = [newLine, token];
                                end
                                newLine = [newLine, line(extents{k}(2)+1:extents{k+1}(1)-1)];
                            end
                            lines{j} = newLine;
                        end
                    end
                    fid = fopen(fileList{i},'w');
                    for j = 1:length(lines)
                        fprintf(fid, '%s\n', lines{j});
                    end
                    fclose(fid);
                end
                pb.finish;
            end

            % Now launch sphinx in modified folder
            disp('Running Sphinx');
            lastPath = pwd;
            cd(pathStr);
            cmd = 'sphinx-build -b html _sphinx docs';
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
