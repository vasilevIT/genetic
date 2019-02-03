
f_vals = [10 10; 40 30; 30 60; 60 65];
f_results = zeros(4,2);
for i = 1:4
    f_results(i, 1) = Fuu1(f_vals(i, 1), f_vals(i, 2));
    f_results(i, 2) = Fuu2(f_vals(i, 1), f_vals(i, 2));
end
nash = get_nash(f_results, f_vals);
disp(f_vals);
disp(f_results);
disp(nash);
plot_nash(f_results, nash,1);