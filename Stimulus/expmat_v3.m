function expTable = expmat_v3(varargin)
% to create expTable

% Input: 'VarName1',Var1,'VarName2',Var2,...
% For 'rep', it is detected to the number of replication.
% If variable is input without levels (such as 'VarName1','VarName2'...), NaN will be filled. (v3 update)
% Error comes up when input is merely 'VarName1'. Don't input this sorely (v3)

%% check data type of varargin
randVar = {}; NanVar = {}; rep = 1;
for cnt = 1:length(varargin)
    if cnt == 1 
        if ~ischar(varargin{cnt})
            error('varargin{1} should be char type.')   
        end
    else
        if ~ischar(varargin{cnt-1}) && ~ischar(varargin{cnt})
            error(['varargin{' num2str(cnt) '} should be char type.'])
        elseif ischar(varargin{cnt-1}) && ~ischar(varargin{cnt})
            if strcmp(varargin{cnt-1},'rep')
                rep = varargin{cnt};
            else
                randVar(end+1,:) = {varargin{cnt-1}, varargin{cnt}};
            end
        elseif ischar(varargin{cnt-1}) && ischar(varargin{cnt})
            NanVar(end+1,:) = {varargin{cnt-1}};
        end
    end
    if cnt == length(varargin) && ischar(varargin{cnt})
        NanVar(end+1,:) = {varargin{cnt}};
    end
end


emat = repmat(expmat(randVar{:,2}),rep,1);
emat = [randperm(size(emat,1))' emat];

expTable = array2table(emat);
expTable.Properties.VariableNames = {'Order' randVar{:,1}};

if ~isempty(NanVar)
    for cnt = 1:length(NanVar)
        expTable.(NanVar{cnt}) = nan(height(expTable),1);
    end
end



end

function mat = expmat(varargin)
	mat = [];
	for i = length(varargin):-1:1
		conds = length(varargin{i});
		mat = repmat(mat, conds, 1);
		trials = max([conds, size(mat, 1)]);
		mat = [reshape(repmat(varargin{i}, trials / conds, 1), trials, 1), mat]; %#ok<AGROW>
	end
end