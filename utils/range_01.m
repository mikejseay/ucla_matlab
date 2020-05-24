function v_out = range_01(v_in)

v_out = (v_in - min(v_in)) ./ (max(abs(v_in)) - min(abs(v_in)));

end