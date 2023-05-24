% x�� �� ����
x = [1:60; 1:60; 1:60]';
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


figure;
subplot(1, 3, 1);
scatter(x(:, 1), zero_y);
xlabel('Zero');
ylabel('zero_Hz');
ylim([0 10]);

subplot(1, 3, 2);
scatter(x(:, 2), low_y);
xlabel('Low');
ylabel('low_Hz');
ylim([0 10]);

subplot(1, 3, 3);
scatter(x(:, 3), high_y);
xlabel('High');
ylabel('high_Hz');
ylim([0 10]);


% scatter(x(:, 1), zero_y);
% hold on;
% scatter(x(:, 2), low_y);
% scatter(x(:, 3), high_y);
% hold off;
% labels = ["Zero", "Low", "High"];
% 
% % �׷��� Ÿ��Ʋ, x�� ��, y�� �� �߰�
% title('Zero vs. Low vs. High');
% xlabel(labels);
% ylabel('Hz');
% 
% for i = 1:length(labels)
%     text(x(i)+i*i, -10, labels(i), 'HorizontalAlignment', 'center');
% end
% x(3) = x(3) - 25;

%%
scatter(x, low_y);

title('Zero vs. low vs. high');
xlabel('Low');
ylabel('Hz');


scatter(x, high_y);

title('Zero vs. low vs. high');
xlabel('High');
ylabel('Hz');
%%
% ���ڿ� �迭�� ���� ���� x �� ���̺� ����
x = 1:10;
y = x.^2;
labels = ["Label 1", "Label 2", "Label 3"];
plot(x, y);
xlabel(labels);

% �ؽ�Ʈ ��ü�� ���� ���� x �� ���̺� ����
x = 1:10;
y = x.^2;
labels = ["Label 1", "Label 2", "Label 3"];
plot(x, y);
for i = 1:length(labels)
    text(x(i)+i, -10, labels(i), 'HorizontalAlignment', 'center');
end