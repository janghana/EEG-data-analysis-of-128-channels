% ���� ������ ����
clockData = rand(100, 3); % Clock ������
antiClockData = rand(100, 3); % Anti-clock ������
lowData = [123*rand(33,1), 123*rand(33,1), 123*rand(33,1)]; % Low ������
zeroData = [123*rand(33,1), 123*rand(33,1), 123*rand(33,1)]; % Zero ������
highData = [123*rand(33,1), 123*rand(33,1), 123*rand(33,1)]; % High ������

% �� ������ ���� �ϳ��� ��Ĩ�ϴ�.
allData = [clockData; antiClockData; lowData; highData; zeroData];

% �� ������ ���� 3���� column�� ���� �־�� �մϴ�. (Zero, Low, High)
% ���� Zero, Low, High�� �ش��ϴ� �����͸� �����մϴ�.
zero = allData(234:end, 1:3);
low = allData(134:233, 1:3);
high = allData(101:133, 1:3);

% Clock, Anti-clock histogram
clockMean = mean(clockData);
clockError = std(clockData)/sqrt(size(clockData, 1));
clockIQR = iqr(clockData);

antiClockMean = mean(antiClockData);
antiClockError = std(antiClockData)/sqrt(size(antiClockData, 1));
antiClockIQR = iqr(antiClockData);

% Low, Zero, High scatter plot
lowMean = mean(low);
lowIQR = iqr(low);

zeroMean = mean(zero);
zeroIQR = iqr(zero);

highMean = mean(high);
highIQR = iqr(high);

% �׷��� �׸���
x = categorical({'Zero', 'Low', 'High'});
barWidth = 0.4;
figure
hold on

% Clock ������
bar(x, clockMean, barWidth, 'FaceColor', 'r');
errorbar(x, clockMean, clockError, 'r.', 'LineWidth', 1.5, 'CapSize', 15);
scatter(x, clockIQR, 'r', 'filled');

% Anti-clock ������
bar(x, antiClockMean, barWidth, 'FaceColor', 'b', 'BarWidth', 0.4);
errorbar(x, antiClockMean, antiClockError, 'b.', 'LineWidth', 1.5, 'CapSize', 15);
scatter(x, antiClockIQR, 'b', 'filled');

% Low ������
scatter(x, lowIQR, 'g', 'filled');
scatter(x, lowMean, 'g');

% Zero ������
scatter(x, zeroIQR, 'm', 'filled');
scatter(x, zeroMean, 'm');

% High ������
scatter(x, highIQR, 'k', 'filled');
scatter(x, highMean, 'k');

hold off

% �� �� ����
ylabel('Data Value');
legend('Clock', 'Clock Error', 'Clock IQR','Anti-Clock', 'Anti-Clock Error', 'Anti-Clock IQR', 'Low IQR', 'Low Mean', 'High IQR', 'High Mean', 'Zero IQR', 'Zero Mean');
