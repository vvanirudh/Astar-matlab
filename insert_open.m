function state = insert_open(xval, yval, tval, parent_x, parent_y, ...
                             parent_t, hn, gn, fn)

state = [];
state(1,1) = 1;
state(1,2) = xval;
state(1,3) = yval;
state(1,4) = tval;
state(1,5) = parent_x;
state(1,6) = parent_y;
state(1,7) = parent_t;
state(1,8) = hn;
state(1,9) = gn;
state(1,10) = fn;

end