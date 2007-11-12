string=sprintf('\n----------------------------------------------------------------------------');disp(string);
disp('Before running AFM_EWA_learning');
disp('----------------------------------------------------------------------------');

%Check the current rule usage before running EWA_learning:
if (TESTMODE)
    HouseholdIDs = fieldnames(DBHouseholds);
    rule_usage_before=[];
    for h=1:numel(HouseholdIDs)
        try
            household = HouseholdIDs{h,1};
            rule_usage_before{h,1} = DBHouseholds.(household).PortfolioAllocationRule.id;
        catch
          %No statements
        end;
    end;
end;

disp('Now running AFM_EWA_learning');
AFM_EWA_learning();

disp('----------------------------------------------------------------------------');
disp('After running AFM_EWA_learning');
disp('----------------------------------------------------------------------------');

%Check the current rule usage after running EWA_learning:
if (TESTMODE)
    rule_usage_after=[];
    for h=1:numel(HouseholdIDs)
        household = HouseholdIDs{h,1};

        try 
            rule_usage_after{h,1} = DBHouseholds.(household).PortfolioAllocationRule.id;
            if ~strcmp(rule_usage_before{h,1},rule_usage_after{h,1})
                rule_change(h)=1;
            else 
                rule_change(h)=0;                
            end;
        catch
          %NO STATEMENTS
        end;
    end;
    disp('Changed rules:')
    rule_change
%    rule_usage_before
%    rule_usage_after
end; 

disp('----------------------------------------------------------------------------');
disp('End of TEST_AFM_EWA_learning');
disp('----------------------------------------------------------------------------');
disp('Press any key to continue.');
pause;
