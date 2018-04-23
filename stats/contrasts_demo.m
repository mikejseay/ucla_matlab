o = [3 -2 -2 -2  3;
     1  0  0  0 -1;
     0  1  1 -2  0; 
     0  1 -1  0  0];
o_imba = [222 -189 -189 -189 222;
          101    0    0    0 -88;
            0   83   83 -139   0;
            0   97  -42    0   0];
group_ns = [88  42   97   83 101];

is_orthogonal(o)

is_orthogonal_imba(o_imba, group_ns)
