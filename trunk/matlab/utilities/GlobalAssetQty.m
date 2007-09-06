function[qty]=GlobalAssetQty(AssetId)

global DBHouseholds

HouseholdsIds = fieldnames(DBHouseholds);

qty = 0;
for h=1:numel(HouseholdsIds)
    id = HouseholdsIds{h,1};
    qty = qty + DBHouseholds.(id).portfolio.(AssetId);
end
