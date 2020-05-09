function   ws = caculate_ws(data,hour_data,height)
    %计算指定高度处的平均风速，并将结果返回给ws，采用MoMM的方法
    time = hour_data{:,1};
    data_size = size(hour_data);
    column = 0;  %所需数据是第index列的数据
    for i = 1:data_size(2)
        if data.Properties.CustomProperties.height(i) == height
            column = i;
        end
    end

    ws_data = hour_data{:,column};
    %计算每个月的数据完整因子，lambda=min(N/(n*psi),1)
    mu = zeros(1,12);    %存储mu，第i个月的风速平均值
    mu_index = zeros(1,12);     %存储第i个月数据点数
    lambda = zeros(1,12);   %存储lambda，第i个月的完整因子,此处用数组存储比用table存储计算时间更短
    psi = [31 28.24 31 30 31 30 31 31 30 31 30 31];      %存储psi，第i个月的平均天数
    molecule = 0;       %分子
    denominator = 0;    %分母
    month = time.Month;
    for mon = 1:12      %求月平均风速
        row = find(month == mon);
        mu(mon) = mean(ws_data(row));
        row_size = size(row);
        mu_index(mon) = row_size(1);
    end
    for mon = 1:12
        lambda(mon) = mu_index(mon)./(144.*psi(mon));
        if lambda(mon) >1
            lambda(mon) = 1;
        end
        temp_molecule = mu(mon).*lambda(mon).*psi(mon);
        if isnan(temp_molecule)
            temp_molecule = 0;
        end
        temp_denominator = lambda(mon).*psi(mon);
        if isnan(temp_denominator)
            temp_denominator = 0;
        end
        molecule = molecule + temp_molecule;
        denominator = denominator + temp_denominator;
    end
    ws = molecule./denominator;
    ws = sprintf('%0.2f',ws);
end
