function v_out = normalize_minmax(v_in)

v_out = (v_in - min(v_in)) ./ max(abs(v_in));

end