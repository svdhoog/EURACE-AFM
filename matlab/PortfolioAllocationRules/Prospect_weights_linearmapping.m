function[weights]= Prospect_weights_linearmapping(utilityvector)

Lengthvector = length(utilityvector);
[sortedvect indexvect] = sort(utilityvector);
positiveindex = find (sortedvect > 0);
weightsvect =  zeros (1,Lengthvector);
weightsvect (positiveindex) = sortedvect (positiveindex) / sum (sortedvect (positiveindex));
for i = 1: Lengthvector
    weigthstmp (indexvect(i)) = weightsvect (i);
end
weights = weigthstmp;