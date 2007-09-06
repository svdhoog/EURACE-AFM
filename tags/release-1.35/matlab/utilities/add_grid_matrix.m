function[grid_matrix]=add_grid_matrix(grid_matrix,grid_vect)

if (size(grid_vect,1)>1)&(size(grid_vect,2)>1)
    error('grid_vect is a matrix')
end

% grid_vect is forced to be a column vector
grid_vect = grid_vect(:);
n = numel(grid_vect);

if isempty(grid_matrix)
    grid_matrix = grid_vect;
else
    grid_matrix_old = grid_matrix;
    clear grid_matrix
    NrRows = size(grid_matrix_old,1);
    NrColumns = size(grid_matrix_old,2);
    
    grid_matrix = NaN*ones(n*NrRows,NrColumns+1);
    grid_matrix(:,1:NrColumns) = repmat(grid_matrix_old,[n, 1]);
    
    for r=1:n
        i0 = (r-1)*NrRows+1;
        i1 = r*NrRows;
        grid_matrix(i0:i1,NrColumns+1) =  grid_vect(r);
    end
end
    
    
    
    