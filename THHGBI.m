
function [DrugTarget, DrugDisease] = THHGBI(DrugTarget, TargetSim, DrugSim, DiseaseMat, DrugDisease, alpha, filter, iter)

% The drug must be overlap between two domains.
 if nargin < 8
        iter = 10;
    end
    if nargin < 7
        filter = 0.2;
    end
    if nargin < 6
        alpha = 0.5;
    end 

    TargetSim(TargetSim < filter) = 0;
    DrugSim(DrugSim < filter) = 0;
    DiseaseMat(DiseaseMat < filter) = 0;
 
    d = DrugSim * DrugDisease * DiseaseMat * DrugDisease';
    d = d ./ ((sum(d,2)*sum(d,1)).^0.5  + 0.005);
    r = DrugTarget' * TargetSim * DrugTarget * DrugSim;
    r = r ./ ((sum(r,2) * sum(r,1)) .^ 0.5 + 0.005);
    Wdr = DrugTarget * d;
    Wrt = r * DrugDisease;
    WdrPrev = DrugTarget;
    WrtPrev = DrugDisease;
  
    for i = 1 : iter
        
        WdrPrev = Wdr;
        WrtPrev = Wrt;
        d = DrugSim * WrtPrev * DiseaseMat * WrtPrev';
        d = d ./ ((sum(d,2) * sum(d,1)) .^ 0.5 + 0.005);
        r = WdrPrev' * TargetSim * WdrPrev * DrugSim;
        r = r ./ ((sum(r,2) * sum(r,1)) .^ 0.5 + 0.005);
        Wdr = alpha * WdrPrev * d + (1 - alpha) * DrugTarget;
        Wrt = alpha * r * WrtPrev + (1 - alpha) * DrugDisease;

    end
    
    DrugTarget = Wdr;
    DrugDisease = Wrt;
end