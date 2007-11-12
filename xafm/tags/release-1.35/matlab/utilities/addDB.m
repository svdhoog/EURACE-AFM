function[DB]=addDB(DB,object)

id = getfield(object,'id');

%%% Checking in the DB for existing id %%% 
tmp1 = fieldnames(DB);
tmp2 = ismember(tmp1,id);
if ~isempty(find(tmp2==1))
%    error('The id already exists in the DB')
end
    
DB = setfield(DB,id,object);


