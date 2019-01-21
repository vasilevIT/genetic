clc,clear all
% Quantity epoch
N= 10;
M = [5,4,3,2;
    1,4,4,7];
disp('Win matrix:');
disp(M);
k=1;
i=1;
j=1;
a_k = [];
b_k = [];
u_k = [0,1];
B = M(1,:);
A = [0,0];
p = [0,0];
q = [0,0,0,0];
while (k < N)
   p(i) = p(i) + 1;
   a_k(k) = min(B)/k;
   [min_val,min_index] = min(B);
   j = min_index; 
   q(j) = q(j) + 1;
   A = A + M(:,j)';
   [max_val,max_index] = max(A());
   b_k(k) = max(A)/k;
   i = max_index;
   B = B + M(i,:);
    u_k(k) = (a_k(k) + b_k(k))/2;
    k = k + 1;
end
% Normalizing probability
for m = 1:size(p,2)
    p(m) = p(m)/(k-1); 
end

for m = 1:size(q,2)
    q(m) = q(m)/(k-1); 
end
disp('Calculating result:');
fprintf('k = %d\n' , (k-1));
fprintf('p=[%.2f,%.2f]; q=[%.2f,%.2f,%.2f,%.2f]; u=%.2f\n',p,q,u_k(k-1));
