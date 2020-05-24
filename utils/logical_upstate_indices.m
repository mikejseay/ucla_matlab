function bool_out = logical_upstate_indices(u_ons, u_off, total_length)

bool_out = false(1, total_length);
n_upstates = length(u_ons);

for upstateInd = 1:n_upstates
    bool_out(u_ons(upstateInd):u_off(upstateInd)) = true;
end

end