function[]=Book_print(AssetId)

% Input:
% AssetId: string related to asset id
%
% Description:
% Print the book content referred to asset AssetId
%
% Version 1.0, August 28th, 2007
%
% For any question, please contact Marco Raberto  

global Book

Asks_values = Book.(AssetId).Asks_values;
Bids_values = Book.(AssetId).Bids_values;

Asks_ids = Book.(AssetId).Asks_ids;
Bids_ids = Book.(AssetId).Bids_ids;

fprintf('\r\r Limit order book values for asset: %s',AssetId)
fprintf('\r Type \t price \t qty \t d0 \t s0 \t df \t sf \t order id \t agent id')

NrAsks = size(Asks_values,1);
NrBids = size(Bids_values,1);

for i=1:NrAsks
    fprintf('\r Ask \t %4.2f \t %4d \t %4d \t %4d \t %4d \t %4d \t %4d \t %s',...
        Asks_values(i,1),Asks_values(i,2),Asks_values(i,3),Asks_values(i,4),...
        Asks_values(i,5),Asks_values(i,6),Asks_values(i,7),Asks_ids.(['t', num2str(Asks_values(i,7))]))
end

for i=1:NrBids
    fprintf('\r Bid \t %4.2f \t %4d \t %4d \t %4d \t %4d \t %4d \t %4d \t %s',...
        Bids_values(i,1),Bids_values(i,2),Bids_values(i,3),Bids_values(i,4),...
        Bids_values(i,5),Bids_values(i,6),Bids_values(i,7),Bids_ids.(['t', num2str(Bids_values(i,7))]))
end

fprintf('\r')

fprintf('\r\r Limit order book ids for asset: %s',AssetId)
if ~isempty(Asks_ids)
    Asks_ids_names = fieldnames(Asks_ids);
    for i=1:numel(Asks_ids_names)
        fprintf('\r Ask \t %s %s',Asks_ids_names{i,1},Asks_ids.(Asks_ids_names{i,1}))
    end
end
if ~isempty(Bids_ids)
    Bids_ids_names = fieldnames(Bids_ids);
    for i=1:numel(Bids_ids_names)
        fprintf('\r Bid \t %s %s',Bids_ids_names{i,1},Bids_ids.(Bids_ids_names{i,1}))
    end
end