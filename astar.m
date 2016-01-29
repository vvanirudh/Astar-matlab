% Astar planner file

% DEBUG
% Set random seed
rng(3);

% Set the dimensions of the map
% Assume 2D for now

xdim = 10;
ydim = 10;

% Set the dimension of the t axis
tdim = 100;

% Create the 3D costmap grid
%COSTMAP = zeros(xdim, ydim, tdim);
COSTMAP = rand(xdim, ydim)*100;

%GVAL = Inf(xdim, ydim, tdim);
%HVAL = zeros(xdim, ydim, tdim);

% Set start and target states
xs = 1;
ys = 1;
ts = 0;

xt = 9;
yt = 9;

% Compute heuristic values for all states
%HVAL = getHeuristicValues(HVAL, xt, yt);

% Create lists that are used by the algorithm
OPEN = [];
CLOSED = [];
OPEN_COUNT = 0;
CLOSED_COUNT = 0;

xNode = xs;
yNode = ys;
tNode = ts;

% Insert start into OPEN
OPEN_COUNT = 1;
%GVAL(xNode, yNode, tNode) = 0;
path_cost = 0;
hval = heuristic(xNode, yNode, xt, yt);

OPEN(OPEN_COUNT, :) = insert_open(xNode, yNode, tNode, xNode, yNode, ...
                                  tNode, 0, hval, hval);

% Pop start from OPEN and put in CLOSED
OPEN(OPEN_COUNT, 1) = 0;
CLOSED_COUNT = 1;
CLOSED(CLOSED_COUNT, 1) = xNode;
CLOSED(CLOSED_COUNT, 2) = yNode;
CLOSED(CLOSED_COUNT, 3) = tNode;

NoPath = 1;

% Start
while ((xNode ~= xt || yNode ~= yt) && NoPath == 1)
    exp_array = expand_array(xNode, yNode, tNode, path_cost, xt, yt, CLOSED, ...
                             xdim, ydim, tdim, COSTMAP);
    exp_count = size(exp_array, 1);
    
    for i=1:exp_count
        flag=0;
        for j=1:OPEN_COUNT
            if (exp_array(i,1) == OPEN(j,2) && exp_array(i,2) == ...
                OPEN(j,3) && exp_array(i,3) == OPEN(j,4))
                OPEN(j,10) = min(OPEN(j,10), exp_array(i,6));
                
                if OPEN(j,10)==exp_array(i,6)
                    OPEN(j,5) = xNode;
                    OPEN(j,6) = yNode;
                    OPEN(j,7) = tNode;
                    OPEN(j,8) = exp_array(i,4);
                    OPEN(j,9) = exp_array(i,5);
                end
                flag = 1;
            end
        end
        
        if flag==0
            OPEN_COUNT = OPEN_COUNT + 1;
            OPEN(OPEN_COUNT, :) = insert_open(exp_array(i,1), ...
                                              exp_array(i,2), ...
                                              exp_array(i,3), xNode, ...
                                              yNode, tNode, ...
                                              exp_array(i,4), ...
                                              exp_array(i,5), ...
                                              exp_array(i,6));
        end
    end
    
    % Pop the next smallest f valued state from OPEN
    index_min_node = min_fn(OPEN, OPEN_COUNT, xt, yt);
    
    if (index_min_node ~= -1)
        xNode = OPEN(index_min_node, 2);
        yNode = OPEN(index_min_node, 3);
        tNode = OPEN(index_min_node, 4);
        path_cost = OPEN(index_min_node, 8);
        
        CLOSED_COUNT = CLOSED_COUNT + 1;
        CLOSED(CLOSED_COUNT, 1) = xNode;
        CLOSED(CLOSED_COUNT, 2) = yNode;
        CLOSED(CLOSED_COUNT, 3) = tNode;
        OPEN(index_min_node, 1) = 0;
    else
        NoPath = 0;
    end
end

i = size(CLOSED, 1);
OptimalPath = [];
xval = CLOSED(i,1);
yval = CLOSED(i,2);
tval = CLOSED(i,3);

i=1;
OptimalPath(i,1) = xval;
OptimalPath(i,2) = yval;
OptimalPath(i,3) = tval;

i=i+1;

if ((xval==xt) && (yval==yt))
    inode = node_index(OPEN, xval, yval, tval);
    
    parent_x = OPEN(inode, 5);
    parent_y = OPEN(inode, 6);
    parent_t = OPEN(inode, 7);
    
    while (parent_x ~= xs || parent_y ~= ys || parent_t ~= ts)
        OptimalPath(i,1) = parent_x;
        OptimalPath(i,2) = parent_y;
        OptimalPath(i,3) = parent_t;
        
        inode = node_index(OPEN, parent_x, parent_y, parent_t);
        parent_x = OPEN(inode, 5);
        parent_y = OPEN(inode, 6);
        parent_t = OPEN(inode, 7);
        i = i + 1;
    end
    
    OptimalPath(i,1) = parent_x;
    OptimalPath(i,2) = parent_y;
    OptimalPath(i,3) = parent_t;
    
    
    j = size(OptimalPath, 1);
end

fprintf('Optimal Path is : \n');
flipud(OptimalPath)
fprintf('\n Cost of the optimal path: %f\n', path_cost);