function v_store = create_noisy_series(sigma, tau, dt, total_sim)

v_init = 0;

v_store = zeros(round(total_sim / dt), 1);
v_store(1) = v_init;
current_v = v_init;
for t_step = 2:length(v_store)
    
    
    dv = (-current_v/tau + sigma * sqrt(2/tau) * randn) / dt;
    current_v = current_v + dv;
    v_store(t_step) = current_v;
    
end

end