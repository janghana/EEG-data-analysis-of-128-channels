% ���� ������ ����

% ���� �׷��� �׸���
figure;
x = [0, 1.9, 3.5]; % x�� ��
y = [0.0107 4.1113 5.7002]; % y�� �� �ʱ�ȭ

colors = ['r', 'g', 'b']; % ���� ��
for i = 1:length(x)
    bar(x(i), y(i), 0.5, 'FaceColor', colors(i), 'EdgeColor', 'none'); % ���� �׷���
    hold on;
end
xticks(x);
xticklabels({'Zero', 'Low', 'High'});
ylabel('Hz');
title('Anti-Clock-Wise Total Average Data');

for i = 1:length(y)
    text(x(i), y(i)+0.1, num2str(y(i)), 'HorizontalAlignment', 'center');
end
