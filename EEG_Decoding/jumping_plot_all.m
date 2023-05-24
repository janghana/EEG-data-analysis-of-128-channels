% 예시 데이터 생성
clockData = rand(100, 3); % Clock 데이터
antiClockData = rand(100, 3); % Anti-clock 데이터
lowData = [123*rand(33,1), 123*rand(33,1), 123*rand(33,1)]; % Low 데이터
zeroData = [123*rand(33,1), 123*rand(33,1), 123*rand(33,1)]; % Zero 데이터
highData = [123*rand(33,1), 123*rand(33,1), 123*rand(33,1)]; % High 데이터

% 각 데이터 셋을 하나로 합칩니다.
allData = [clockData; antiClockData; lowData; highData; zeroData];

% 각 데이터 셋은 3개의 column을 갖고 있어야 합니다. (Zero, Low, High)
% 따라서 Zero, Low, High에 해당하는 데이터를 추출합니다.
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

% 그래프 그리기
x = categorical({'Zero', 'Low', 'High'});
barWidth = 0.4;
figure
hold on

% Clock 데이터
bar(x, clockMean, barWidth, 'FaceColor', 'r');
errorbar(x, clockMean, clockError, 'r.', 'LineWidth', 1.5, 'CapSize', 15);
scatter(x, clockIQR, 'r', 'filled');

% Anti-clock 데이터
bar(x, antiClockMean, barWidth, 'FaceColor', 'b', 'BarWidth', 0.4);
errorbar(x, antiClockMean, antiClockError, 'b.', 'LineWidth', 1.5, 'CapSize', 15);
scatter(x, antiClockIQR, 'b', 'filled');

% Low 데이터
scatter(x, lowIQR, 'g', 'filled');
scatter(x, lowMean, 'g');

% Zero 데이터
scatter(x, zeroIQR, 'm', 'filled');
scatter(x, zeroMean, 'm');

% High 데이터
scatter(x, highIQR, 'k', 'filled');
scatter(x, highMean, 'k');

hold off

% 축 및 범례
ylabel('Data Value');
legend('Clock', 'Clock Error', 'Clock IQR','Anti-Clock', 'Anti-Clock Error', 'Anti-Clock IQR', 'Low IQR', 'Low Mean', 'High IQR', 'High Mean', 'Zero IQR', 'Zero Mean');
