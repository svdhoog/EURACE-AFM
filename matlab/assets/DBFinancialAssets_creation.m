function[]=DBFinancialAssets_creation()

global DBFinancialAssets Parameters

DBFinancialAssets.dummy = 'Dummy';

for n=1:numel(Parameters.Stocks.Ids)
    id = Parameters.Stocks.Ids{n,1};
    stock = stock_creation(id);
    DBFinancialAssets = addDB(DBFinancialAssets,stock);
    clear id stock
end

for n=1:numel(Parameters.Bonds.Ids)
    id = Parameters.Bonds.Ids{n,1};
    bond = bond_creation(id);
    DBFinancialAssets = addDB(DBFinancialAssets,bond);
    clear id bond
end

DBFinancialAssets = rmfield(DBFinancialAssets,'dummy');