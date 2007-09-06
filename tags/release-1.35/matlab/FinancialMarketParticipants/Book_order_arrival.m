function[]=Book_order_arrival(AssetId,p,q,id_num)

global Book

if q>0  % buy order
    Asks = Book.(AssetId).Asks;
    if p>=Asks.p  % the order becomes a market order
    else
    end
end

