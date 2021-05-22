function [Q] = ElectroStaticDipoles(XYZ, R, F)
    N = length(R)
    Obrlen = zeros(N)
    %Зададим матрицу обратных расстояний для подсчета потенциалов 
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
    %Зададим аналог матрицы обратных расстояний с учетом диполей
   T = zeros(4*N)
    for i = [1:1:N]
        for j = [1:1:N]
            T(i,j) = Obrlen(i,j)
            T(i,j+N) =   (XYZ(i,1) - XYZ(j,1))*Obrlen(i,j)^3
            T(i,j+2*N) = (XYZ(i,2) - XYZ(j,2))*Obrlen(i,j)^3
            T(i,j+3*N) = (XYZ(i,3) - XYZ(j,3))*Obrlen(i,j)^3
            for k =[1:1:3]
            T(i+k*N,j) = (XYZ(i,1) - XYZ(j,1))*Obrlen(i,j)^3
            T(i+k*N,j+N) =   3*(XYZ(i,k) - XYZ(j,k))*(XYZ(i,1) - XYZ(j,1))*Obrlen(i,j)^5 - Obrlen(i,j)^3
            T(i+k*N,j+2*N) = 3*(XYZ(i,k) - XYZ(j,k))*(XYZ(i,2) - XYZ(j,2))*Obrlen(i,j)^5
            T(i+k*N,j+3*N) = 3*(XYZ(i,k) - XYZ(j,k))*(XYZ(i,3) - XYZ(j,3))*Obrlen(i,j)^5
            end
            
        end
    end
    %Решение уравнений
    E = zeros(3*N,1)
    FE = [F; E]
    P = T\FE
    Q = P(1:N,1)'
    D = [P(N+1:2*N,1), P(2*N+1:3*N,1), P(3*N+1:4*N,1)]