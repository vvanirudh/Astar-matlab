function exp_array = expand_array(node_x, node_y, node_t, hn, xt, ...
                                  yt, CLOSED, xdim, ydim, tdim, COSTMAP)


exp_array = [];
exp_count = 1;
c2 = size(CLOSED, 1);

for k=1:-1:-1
    for j=1:-1:-1
        if (k~=j || k~=0)
            s_x = node_x + k;
            s_y = node_y + j;
            s_t = node_t + 1; % Constant time addition
            if ( (s_x > 0 && s_x <= xdim) && (s_y >0 && s_y <= ...
                                              ydim)) % Not checking
                                                     % time bounds
                flag = 1;
                for c1=1:c2
                    if (s_x == CLOSED(c1,1) && s_y == CLOSED(c1, ...
                                                             2))
                        flag = 0;
                    end
                end
                
                if flag==1
                    exp_array(exp_count, 1) = s_x;
                    exp_array(exp_count, 2) = s_y;
                    exp_array(exp_count, 3) = s_t;
                    
                    %exp_array(exp_count, 4) = hn + distance (node_x, ...
                    %                                         node_y, ...
                    %                                         s_x, ...
                    %                                         s_y);
                    exp_array(exp_count, 4) = hn + COSTMAP(node_x, ...
                                                           node_y) ...
                        + COSTMAP(s_x, s_y);                    
                    
                    exp_array(exp_count, 5) = heuristic(node_x, node_y, xt, ...
                                                        yt);
                    
                    exp_array(exp_count, 6) = exp_array(exp_count, ...
                                                        4) + ...
                        exp_array(exp_count, 5);
                    
                    exp_count = exp_count + 1;
                end
            end
        end
    end
end

end