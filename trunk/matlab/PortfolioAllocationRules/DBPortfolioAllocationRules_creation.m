function[DBPortfolioAllocationRules]=DBPortfolioAllocationRules_creation(PortfolioAllocationRules)

DBPortfolioAllocationRules.Dummy = 'Dummy';

PortfolioAllocationRules_classes = fieldnames(PortfolioAllocationRules);

for r=1:numel(PortfolioAllocationRules_classes)
    PortfolioAllocationRules_class = PortfolioAllocationRules_classes{r,1};
    Parameters_names = ...
        fieldnames(PortfolioAllocationRules.(PortfolioAllocationRules_class).Parameters_grids);

    grid_matrix = [];

    for n=1:numel(Parameters_names)
        Parameters_name = Parameters_names{n,1};
        grid_values = ...
            PortfolioAllocationRules.(PortfolioAllocationRules_class).Parameters_grids.(Parameters_name);
        grid_matrix = add_grid_matrix(grid_matrix,grid_values);
        clear Parameters_name grid_values
    end

    NrParametersCombinations = size(grid_matrix,1);

    for c=1:NrParametersCombinations
        PortfolioAllocationRule.id = [PortfolioAllocationRules_class, '_', num2str(c)];
        PortfolioAllocationRule.class = PortfolioAllocationRules_class;
        for n=1:numel(Parameters_names)
            Parameters_name = Parameters_names{n,1};
            PortfolioAllocationRule.(Parameters_name) = grid_matrix(c,n);
            clear Parameters_name
        end
        DBPortfolioAllocationRules = addDB(DBPortfolioAllocationRules,PortfolioAllocationRule);
        clear PortfolioAllocationRule
    end

end

DBPortfolioAllocationRules = rmfield(DBPortfolioAllocationRules,'Dummy'); 