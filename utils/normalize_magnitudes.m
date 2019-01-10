function v_out = normalize_magnitudes(v_in)

v_out = v_in ./ max(abs(v_in));

end