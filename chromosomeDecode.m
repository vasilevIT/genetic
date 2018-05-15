function l = chromosomeDecode(z)
n = size(z, 2);
s1 = z(1) * 2 ^ (n - 1);
s2 = 0;
for j = 2: (n - 1)
    sum = 0;
    for k = 1:j-1
        sum = sum + z(k);
    end
    sum = mod(sum, 2);
    sum = sum * (1 - 2 * z(j)) + z(j);
    sum = sum * (2 ^ (n - j));
    s2 = s2 + sum;
end
sum = 0;
for j = 1: (n - 1)
    sum = sum + z(j);
end
sum = mod(sum, 2);
s3 = sum * (1 - 2 * z(n - 1));
s4 = z(n - 1);
l = s1 + s2 + s3 + s4;