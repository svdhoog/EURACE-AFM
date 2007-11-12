function[]=BookDailySession(AssetId,d)

global Parameters Book DBHouseholds DBFinancialAssets

Book.Asks = [];
Book.Bids = [];

HouseholdsId = fieldnames(DBHouseholds);
NrHouseholds = numel(HouseholdsId);

IdsHouseholds_permuted = randperm(NrHouseholds);

Book.AssetId;

for a=1:NrHouseholds
    id_num = IdsHouseholds_permuted(a);
    household = DBHouseholds.(['household_', num2str(id_num)]);
    p = tmp(1);
    q = tmp(2);
    order_nr = a;
    Book_limit_order_insert(AssetId,p,q,order_nr,id_num)
    clear id_num p q household
end