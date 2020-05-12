function [A, B, objs] = GRMF(X, Sa, Sb, rank, p, para)

if nargin < 4
    rank = 100;
end


if nargin < 5
    p = 5;
end

if nargin < 6
    para = [0.1, 0.1, 0.1];
end

[row, col] = size(X);
Sa = PNN(Sa, p);
Sb = PNN(Sb, p);


La = diag(sum(Sa)) - Sa;
La = (diag(sum(Sa))^(-0.5))*La*(diag(sum(Sa))^(-0.5));
Lb = diag(sum(Sb)) - Sb;
Lb = (diag(sum(Sb))^(-0.5))*Lb*(diag(sum(Sb))^(-0.5));




% initilized by SVD, require complexity
[row, col] = size(X);
[u,s,v] = svds(X,rank);
A = u*(s^0.5);
B = v*(s^0.5);

maxIter = 200;
Iter = 1;

% update A and B
while Iter <= maxIter 
    
    % Update A
    A = (X*B - para(2) * La *A)/(B'*B + para(1)*eye(rank));
    % Update B 
    B = (X'*A - para(3) * Lb *B)/(A'*A + para(1)*eye(rank))^(-1); 
    Iter = Iter + 1;

end
end
      
function S=PNN(S,p)
    N = zeros(size(S));
    for j=1:length(N)
        row = S(j,:);                           
        row(j) = 0;                              
        [~,index] = sort(row,'descend');          
        index = index(1:p);                        
        N(j,index) = S(j,index);              
        N(j,j) = S(j,j);                    
    end
    S = (N+N')/2;

end