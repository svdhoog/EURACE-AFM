function[]=DBAMCs_creation(Parameters)

global DBFinancialAssets DBAMCs Parameters

DBAMCs.dummy = 'Dummy';
for h=1:Parameters.NrAMCs
    id = num2str(h);
    AMC = AMC_creation(id);
    DBAMCs = addDB(DBAMCs,AMC);
    
    AMC.learning = 'EWA';
%    AMC.learning = 'None';
    AMC.EWA_learning.rho = Parameters.Households.EWA_learning.rho;
    AMC.EWA_learning.delta = Parameters.Households.EWA_learning.delta;
    AMC.EWA_learning.phi = Parameters.Households.EWA_learning.phi;
    AMC.EWA_learning.beta = Parameters.Households.EWA_learning.beta;
    
    DBAMCs.(AMC.id) = AMC;
    
    clear AMC
end
DBAMCs = rmfield(DBAMCs,'dummy');