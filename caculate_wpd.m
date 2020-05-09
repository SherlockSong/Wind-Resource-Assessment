function wpd = caculate_wpd(data,hour_data,height,P,Temp)
    %����50m�߶ȴ��繦���ܶ�
    wpd = 0;
    if isequal(P,0) || isequal(Temp,0)
        rho = 1.25;
    else
        rho = P*1000/(287*(273+Temp));
    end
    data_size = size(hour_data);
    column = 0;
    for i = 1:data_size(2)
        if isequal(data.Properties.CustomProperties.height(i) , height)
            column = i;
        end
    end

    if column ~= 0      %���50m�߶��з������ݣ�ִ����������
        ws_data = hour_data{:,column};
        all_wpd = 1/2.*rho.*ws_data.^3;
        wpd = mean(all_wpd);
        wpd = round(wpd);
    end
end
