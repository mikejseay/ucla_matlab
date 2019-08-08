function s = create_or_append_field(s, fieldname, value)

if isfield(s, fieldname)
    old_value = getfield(s, fieldname);
    new_value = stack(old_value, value, 1);
    s = setfield(s, fieldname, new_value);
else
    s = setfield(s, fieldname, value);
end

end