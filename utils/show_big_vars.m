
CLEAR_SIZE_THRESH = 2e8;

var_struct = whos;
var_struct = rmfield(var_struct, 'global');
var_struct = rmfield(var_struct, 'persistent');
var_table = struct2table(var_struct);
% var_table_size = sortrows(var_table, 'bytes', 'descend');
vars_to_clear = var_table.name(var_table.bytes > CLEAR_SIZE_THRESH);
% clear(vars_to_clear{:});
