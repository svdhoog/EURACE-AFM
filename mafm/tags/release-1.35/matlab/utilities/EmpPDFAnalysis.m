function[PDFdata_y, PDFdata_x, PDFnorm_y]=EmpPDFAnalysis(data,NrBins,xVect_fit)

[Hdata_y, Hdata_x]=hist(data,NrBins);

Fdata_y = Hdata_y/sum(Hdata_y);

PDFdata_y = Fdata_y/(Hdata_x(2)-Hdata_x(1));
PDFdata_x = Hdata_x;

m = mean(data);
s = std(data);

PDFnorm_y = normpdf(xVect_fit,m,s);





