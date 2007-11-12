function[g_coeff]=gini_coefficient(reddito)

%redditi ordinati crescenti
reddito_sort=sort(reddito);
num=length(reddito);
tot_reddito=0;
%sommo tutti i redditi
for i=1:num
    tot_reddito=reddito(i)+tot_reddito;
end

%normalizzo redditi
for i=1:num
    reddito_norm(i)=reddito_sort(i)/tot_reddito;
end

reddito_cum(1)=reddito_norm(1);
for i=2:num
    reddito_cum(i)=reddito_cum(i-1)+reddito_norm(i);
end

for i=1:num
    x(i) = i/num;
end

%integrale discreto
h=1/num;


area_tot=(reddito_cum(1)*(h))/2;
for i=1:num-1
    area=((reddito_cum(i)+reddito_cum(i+1))*h)/2;
    area_tot=area_tot+area;
end
area_tot;

a=0;

for i=1:num
    if reddito_cum(i)==0
        a=i;
    end 
end

errore=0;

if a==num-1
    errore=1/num;
end

g_coeff=1-2*area_tot+errore;




