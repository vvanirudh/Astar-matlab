function i_min = min_fn (OPEN, OPEN_COUNT, xt, yt)

temp = [];
k=1;
flag=0;
goal_index=0;

for j=1:OPEN_COUNT
    if (OPEN(j,1) == 1)
        temp(k,:) = [OPEN(j,:) j];
        %if (OPEN(j,2) == xt && OPEN(j,3)==yt) % Doubtful stuff
        %    flag = 1;
        %    goal_index = j;
        %end
        k = k + 1;
    end
end

%if flag == 1
%    i_min = goal_index;
%end

if (size(temp, 1) ~= 0)
    [min_fn, temp_min] = min(temp(:,10));
    i_min = temp(temp_min, 11);
else
    i_min = -1;
end


end