clear all;
d = [];

for  i = 1:36000
    x1 = rand(1, 1)*7500;
    y1 = rand(1, 1)*8000;

    temp = 0;

    while (temp < 600)
        x2 = rand(1, 1)*7500;
        y2 = rand(1, 1)*8000;
        temp = sqrt((x1-x2)^2 + (y1-y2)^2);
    end
    d = [ d; temp];

end

edges = 0: 90 : 10000;
[n, bin] = histc(d, edges);
figure
bar(edges,n,'histc')