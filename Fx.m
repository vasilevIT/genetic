function y = Fx(f,u1, u2)
% tic
% F = inline(f);
% disp(f);
% disp('inline');
% disp(toc);
% tic;
% disp('calc');
y = f(u1,u2);
% disp(toc);
