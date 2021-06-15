function [kappa_list, elist] = goldenSection(f, x0, x1, N)

a0 = x0;
b0 = x1;

r = (sqrt(5)-1)/2;

alist = zeros(N,1);
blist = zeros(N,1);
elist = [];
kappa_list = [];

a = a0;
b = b0;

s = a + (1-r)*(b-a);
t = b - (1-r)*(b-a);

x = s;
f1 = feval(f,x);

x = t;
f2 = feval(f,x);

for n = 1:N

    if f1 < f2
        b = t;
        t = s;
        s = a+(1-r)*(b-a);
        f2 = f1;

        x = s;
        f1 = feval(f,x);
        elist = [elist; f1];
        kappa_list = [kappa_list; x];
    else
        a = s;
        s = t;
        t = b-(1-r)*(b-a);
        f1 = f2;

        x = t;
        f2 = feval(f,x);
        elist = [elist; f2];
        kappa_list = [kappa_list; x];
    end
    alist(n) = a;
    blist(n) = b;
end