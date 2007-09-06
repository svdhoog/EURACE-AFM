function[]=DBFirms_creation()

global Parameters DBFirms

DBFirms.dummy = 'Dummy';

for h=1:Parameters.NrFirms
    id = num2str(h);
    firm = firm_creation(id);
    DBFirms = addDB(DBFirms,firm);
    clear firm
end

DBFirms = rmfield(DBFirms,'dummy');
  
    
     

