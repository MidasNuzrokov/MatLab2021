function [Q] = ElectroStaticBalls(XYZ, R, F)
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

    %Решим линейную систему и тем самым найдём распределение зарядов
    Q = Obrlen\F
    