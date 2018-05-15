function z = chromosomeEncode(x, k)
z = zeros(1, k);
d_ = x;
for i = k:-1:1
    d = fix(d_ / (1 + 1));
    z(i) = mod(d, 2) * (1 - 2 * mod(d_, (1 + 1))) + mod(d_, (1 + 1));
    d_ = d;
end
  