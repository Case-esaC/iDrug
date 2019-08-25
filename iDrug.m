function [U, V, objs] = iDrug(X, w, Au, Av, S, rank1, rank2, para)
% Summary of iDrug function
%   The function solves the cross-domain recommendation for two tasks.
%   Task 1: drug-disease association and Task 2: drug-target assoication.

% INPUT:
% X: contains X{1} for known drug-disease associations matrix, 
%    and X{2} for known drug-target association matrix
% w: the weight constant for defined the weight matrix W
% Au: AU{1} and AU{2} contain the drug-drug similarity for two tasks
% Av: Av{1} contain disease-disease similarity for task 1
%     Av{2} contain target-target similarity for task 2
% S: the mapping matrix for overlap of drugs between two tasks
% rank1, rank2: the rank of the latent factor matrix U{1} and U{2}
% para: contain the regulairzed parameters: [alpha, beta, gamma] 

% OUTPUT:
% U, V: the latent matrix for two tasks:U{1}, U{2} and V{1} V{2}

if nargin < 8
    para = [0.01, 0.01, 0.01];
end

% Initilization
rank = [rank1, rank2];

for i = 1:2
    [row, col] = size(X{i});
    U{i} = rand(row, rank(i));
    U{i} = U{i}/sqrt(trace(U{i}'*U{i}));
    V{i} = rand(col, rank(i));
    V{i} = V{i}/sqrt(trace(V{i}'*V{i}));
end

% compute R{i}
for i = 1:2
    R{i} = U{i}*V{i}';
    R{i}(X{i}==0) = 0;
end

Iter = 1;
maxIter = 200;
epsilon = 1e-4;
relErr = 10e8;
Jopt1 = objectiveValue(X, U, V, w, Au, Av, S, para);
objs = [Jopt1];


% Update U{i} and V{i} alternately
SS = S'*S;
while Iter <= maxIter && relErr > epsilon
    
    % Update U{1}
    [row1, ~] = size(Au{1});
    num = X{1}*V{1} + para(1)*Au{1}*U{1};
    num = num + 2*para(2)*S'*U{2}*U{2}'*S*U{1};
    den = ((1-w^2)*R{1} + w^2*U{1}*V{1}')*V{1} + para(1)*spdiags(sum(Au{1},2),0,row1,row1)*U{1};
    den = den + 2*para(2)*S'*S*U{1}*U{1}'*SS*U{1} + 0.5*para(3);
    U{1} = U{1}.*((num./den).^(0.5));
    
    % Update U{2}
    [row2, ~] = size(Au{2});
    num = X{2}*V{2} + para(1)*Au{2}*U{2};
    num = num + 2*para(2)*S*U{1}*U{1}'*S'*U{2};
    den = ((1-w^2)*R{2} + w^2*U{2}*V{2}')*V{2} + para(1)*spdiags(sum(Au{2},2),0,row2,row2)*U{2};
    den = den + 2*para(2)*U{2}*U{2}'*U{2} + 0.5*para(3);
    U{2} = U{2}.*((num./den).^(0.5));
    
    % Update V{i}
    for i = 1:2
         [row, ~] = size(Av{i});
         num = X{i}'*U{i} + para(1)*Av{i}*V{i};
         den = ((1-w^2)*R{i}' + w^2*V{i}*U{i}')*U{i} +  para(1)*spdiags(sum(Av{i},2),0,row,row)*V{i} + 0.5*para(3);
         V{i} = V{i}.*((num./den).^(0.5));
    end

    for i = 1:2
        R{i} = U{i}*V{i}';
        R{i}(X{i}==0) = 0;
    end
    
    Jopt2 = objectiveValue(X, U, V, w, Au, Av, S, para);
    relErr = Jopt1 - Jopt2;
    objs = [objs, Jopt2];
    Jopt1 = Jopt2;
    Iter = Iter + 1;

end


end
      

%%% compute the value of the objective function
function J = objectiveValue(X, U, V, w, Au, Av, S, para)
% construct the W weight matrix
for i = 1:2
    W{i} = ones(size(X{i})) * w;
    W{i}(X{i} > 0) = 1;
end

% construct the laplacian matrix Lu and Lv
for i = 1:2
    [row1, ~] = size(Au{i});
    [row2, ~] = size(Av{i});
    Lu{i} = Au{i} - spdiags(sum(Au{i},2),0,row1,row1);
    Lv{i} = Av{i} - spdiags(sum(Av{i},2),0,row2,row2);
end


J = 0;

for i = 1:2
    J = J + norm(W{i}.*(X{i} - U{i}*V{i}'), 'fro')^2;
    J = J + para(1)* (trace(U{i}'* Lu{i} * U{i}) + trace(V{i}'* Lv{i} * V{i}));
    J = J + para(3) * (sum(U{i}(:)) + sum(V{i}(:)));
end

J = J + para(2) * norm(S*U{1}*(S*U{1})' - U{2}*U{2}', 'fro')^2;

end

