function   ws = caculate_ws(data,hour_data,height)
    %����ָ���߶ȴ���ƽ�����٣�����������ظ�ws������MoMM�ķ���
    time = hour_data{:,1};
    data_size = size(hour_data);
    column = 0;  %���������ǵ�index�е�����
    for i = 1:data_size(2)
        if data.Properties.CustomProperties.height(i) == height
            column = i;
        end
    end

    ws_data = hour_data{:,column};
    %����ÿ���µ������������ӣ�lambda=min(N/(n*psi),1)
    mu = zeros(1,12);    %�洢mu����i���µķ���ƽ��ֵ
    mu_index = zeros(1,12);     %�洢��i�������ݵ���
    lambda = zeros(1,12);   %�洢lambda����i���µ���������,�˴�������洢����table�洢����ʱ�����
    psi = [31 28.24 31 30 31 30 31 31 30 31 30 31];      %�洢psi����i���µ�ƽ������
    molecule = 0;       %����
    denominator = 0;    %��ĸ
    month = time.Month;
    for mon = 1:12      %����ƽ������
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
