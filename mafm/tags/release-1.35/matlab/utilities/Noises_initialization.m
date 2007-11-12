
noises_mu = zeros(1,Parameters.NrFirms+1);

noises_sigma = eye(Parameters.NrFirms+1);

% for i=1:(Parameters.NrFirms-1)
%     for j=(i+1):Parameters.NrFirms
%         noises_sigma(i,j) = rand-0.5;
%         noises_sigma(j,i) = noises_sigma(i,j);
%     end
% end
% 
% noises_sigma(1:end-1,end) = linspace(0,0.1,Parameters.NrFirms);
% noises_sigma(end,1:end-1) = noises_sigma(1:end-1,end)';

noises_sigma(1,2) = 0.4;
noises_sigma(2,1) = noises_sigma(1,2);

noises_sigma(1,3) = 0;
noises_sigma(3,1) = noises_sigma(1,3);

noises_sigma(2,3) = 0.25;
noises_sigma(3,2) = noises_sigma(2,3);

rn = mvnrnd(noises_mu,noises_sigma,Parameters.NrTotalMonths);

for i=1:Parameters.NrFirms
    Ids = fieldnames(DBFirms);
    id = Ids{i,1};
    Noises.(id) = rn(:,i);
end

Noises.wage_dynamics = rn(:,end);
Noises.sigma = noises_sigma;