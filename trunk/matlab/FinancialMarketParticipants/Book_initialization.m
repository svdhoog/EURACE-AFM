FinancialAssetsIds = fieldnames(DBFinancialAssets);



for i=1:numel(FinancialAssetsIds)
    id = FinancialAssetsIds{i,1};
    Book.(id).Asks_values = [];
    Book.(id).Asks_ids = [];
    Book.(id).Bids_values = [];
    Book.(id).Bids_ids = [];
    clear id
end

