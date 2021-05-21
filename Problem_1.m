%Строим правую часть спирали
t =0:0.1:200
t = nthroot(abs(t),2)
z = fresnelc(t)
y = fresnels(t)
figure;
plot(z, y )
grid on
hold on
%Строим левую часть спирали
k =0:0.1:200
k = -nthroot(k,2)
z = fresnelc(k)
y = fresnels(k)
plot(z, y )
hold off