function[]=Book_empty(AssetId)

global Parameters Book

t = Parameters.current_day;

Asks_values = Book.(AssetId).Asks_values;
Bids_values = Book.(AssetId).Bids_values;

Asks_ids = Book.(AssetId).Asks_ids;
Bids_ids = Book.(AssetId).Bids_ids;

Asks_values_new = [];
Bids_values_new = [];

Asks_ids_new = [];
Bids_ids_new = [];

if ~isempty(Asks_values)
    for i=size(Asks_values,1)
        if Asks_values(i,5)>=t
            Asks_values_new = [Asks_values_new; Asks_values(i,:)];
            order_id = ['t', num2str(Asks_values(i,7))];
            agent_id = Asks_ids.(order_id);
            Asks_ids_new = setfield(Asks_ids_new,order_id,agent_id);
            clear order_id agent_id
        end
    end
end

if ~isempty(Bids_values)
    for i=size(Bids_values,1)
        if Bids_values(i,5)>=t
            Bids_values_new = [Bids_values_new; Bids_values(i,:)];
            order_id = ['t', num2str(Bids_values(i,7))];
            agent_id = Bids_ids.(order_id);
            Bids_ids_new = setfield(Bids_ids_new,order_id,agent_id);
            clear order_id agent_id
        end
    end
end

Book.(AssetId).Asks_values = Asks_values_new;
Book.(AssetId).Bids_values = Bids_values_new;

Book.(AssetId).Asks_ids = Asks_ids_new;
Book.(AssetId).Bids_ids = Bids_ids_new;