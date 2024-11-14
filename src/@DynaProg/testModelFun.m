function testModelFun(obj)
%testModelFun test model function to check the size of the updated state.

state = obj.StateInitial;
% If using safe mode, expand current state to the combined cv grid
if obj.SafeMode
    for n = 1:length(state)
        state_exp{n} = state{n} + zeros(size(obj.ControlCombGrid{1}));
    end
else
    state_exp = state;
end

% Select the first control in the grid
cv_index = 1;
control =  cellfun(@(x) x(cv_index), obj.ControlGrid, 'UniformOutput', false);

% Create intermediate variables
if obj.UseSplitModel
    intVars = obj.IntermediateVars{k};
    unfeasExt = obj.unFeasExt{k};
else
    intVars = [];
end
% Create exogenous inputs
if obj.UseExoInput
    exoInput_scalar = num2cell(obj.ExogenousInput(1,:));
    if obj.SafeMode
        for n = 1:length(exoInput_scalar)
            exoInput{n} = exoInput_scalar{n}.*ones(size(obj.ControlCombGrid{1}));
        end
    else
        exoInput = exoInput_scalar;
    end
else
    exoInput = [];
    exoInput_scalar = [];
end

% Evaluate state update and stage cost
state_next = model_wrapper(obj, state_exp, control, exoInput, intVars);


% Run checks
% Check the size of the updated states
if length(state_next) ~= length(obj.N_SV)
    error('DynaProg:wrongSizeStateOutput', 'You defined %d SVs through the state grids. However, the model function returns %d SVs.', length(obj.N_SV), length(state_next))
end

end