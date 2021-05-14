function [x,y] = getcenter(img_range)
[m,n] = size(img_range);
total_weight = sum(sum(img_range));
temple = 1:1:m;
xweight = temple'.*ones(m,n);
temple = 1:1:n;
yweight = ones(m,n).*temple;
x = floor(sum(sum(xweight.*img_range))/total_weight);
y = floor(sum(sum(yweight.*img_range))/total_weight);
end