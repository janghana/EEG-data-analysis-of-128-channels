% 예시 데이터 생성

% 막대 그래프 그리기
figure;
x = [0, 1.9, 3.5]; % x축 값
y = [0.0107 4.1113 5.7002]; % y축 값 초기화

colors = ['r', 'g', 'b']; % 색상 값
for i = 1:length(x)
    bar(x(i), y(i), 0.5, 'FaceColor', colors(i), 'EdgeColor', 'none'); % 막대 그래프
    hold on;
end
xticks(x);
xticklabels({'Zero', 'Low', 'High'});
ylabel('Hz');
title('Anti-Clock-Wise Total Average Data');

for i = 1:length(y)
    text(x(i), y(i)+0.1, num2str(y(i)), 'HorizontalAlignment', 'center');
end
