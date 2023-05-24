% x�� �� ����
x = 1:60;
zero_y = [];
low_y = [];
high_y = [];
% y�� �� ����
for i = 1:180
    if expT.pat_vel(i) == 0
        if 1./expT.response(i) == Inf
            zero_y = [zero_y; 0];
        else
            zero_y = [zero_y; 1./expT.response(i)];
        end
    end
    
    if expT.pat_vel(i) == 1.9
        low_y = [low_y; 1./expT.response(i)];
    end
    
    if expT.pat_vel(i) == 3.5
        high_y = [high_y; 1./expT.response(i)];
    end
    
end
% scatter �Լ��� ����Ͽ� �׷��� �׸���
scatter(x, zero_y);

% �׷��� Ÿ��Ʋ, x�� ��, y�� �� �߰�
title('Zero vs. low vs. high');
xlabel('Zero');
ylabel('Hz');


scatter(x, low_y);

title('Zero vs. low vs. high');
xlabel('Low');
ylabel('Hz');


scatter(x, high_y);

title('Zero vs. low vs. high');
xlabel('High');
ylabel('Hz');