function[classifiersystem]=classifiersystem_creation(PortfolioAllocationRules_names)


classifiersystem.dummy='Dummy';

for i=1:numel(PortfolioAllocationRules_names)
    id = PortfolioAllocationRules_names{i,1};
    rule = rule_creation(id);
    classifiersystem=addDB(classifiersystem,rule);
    clear rule id
end

classifiersystem.experience = 0;
classifiersystem = rmfield(classifiersystem,'dummy'); 