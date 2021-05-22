[F,X,Y,P] = SpherePotential(XYZ,Q,R,r0,a,b,Dx,Dy,Nxy)
N = length(R)
M = length(Q)
%Проверка на непересечение шаров друг с другом
for i = [1:1:N]
        for j = [1:1:N]
            if i==j
                Obrlen(i, i) = 1/R(i)
            else 
                Obrlen(i, j) = ((XYZ(1,i) - XYZ(1,j))^2 + (XYZ(2,i) - XYZ(2,j))^2 + (XYZ(3,i) - XYZ(3,j))^2)^(-1/2)
                %Проверим на пересечение шаров
                if (R(i) + R(j)) >= Obrlen(i, j)^(-1)
                    error('The Death Star explodes.')
                end
            end
        end
end
        %Вычислим параметры сетки
        Lx = (Dx(2) - Dx(1))/(Nxy(2) - 1)
        Ly = (Dy(2) - Dy(1))/(Nxy(1) - 1)
        X = (x(1) : Lx : x(2))
        Y = (y(1) : Ly : y(2))
        
        %Найдем матрицу перехода
 
        ex = a/norm(a)
        modb = nthroot((a(2)*b(3)-a(3)*b(2))^2 + (a(3)*b(1)-a(1)*b(3))^2 + (a(1)*b(2)-a(2)*b(1))^2,2)
        ey = b/modb
        ez = cross(ex, ey)/norm(cross(ex, ey))
        P = [ex, ey]
        P1 = [ex, ey, ez]
        r = P1/(XYZ - r0)
        
        %Осталось выссчитать значение потенциалов в каждой точке
%         F = zeros(Nxy(1), Nxy(2))
        for i = [1 : 1 : Nxy(1)]
            for j = [1 : 1:  Nxy(2)] 
                for q = [1 : 1 : M]
            if norm(plane_vec(i, j, q)) < R(q)
                F(i, j) = F(i, j) + Q(q)/R(q) + dot(D(q,:), [X(i, j); Y(i, j); 0] - r(:, q))/R(q)^2
            else
                F(i, j) = F(i, j) + Q(q)/norm([X(i, j); Y(i, j); 0] - r(:, q)) + dot(D(q,:),[X(i, j); Y(i, j); 0] - r(:, q))/norm([X(i, j); Y(i, j); 0] - r(:, q)))^3              
            end
                end
            end
        end
             
        

    %Строим график    
        figure 
    hold on
    grid on
    mesh(X,Y,F)
        