function y = Fx(f,u1, u2)

F = inline(f);
y=F(u1,u2);
