% data = load('/Users/jongrok/Desktop/janghan/psignifit/clock_total_data_1');
% data = load('/Users/jongrok/Desktop/janghan/psignifit/anti_clock_total_data_1');
data = load('/Users/jongrok/Desktop/janghan/psignifit/total_data_1');


% The data format can be changed to the new one with this simple command:
data = data.total_data_1;


scatter(data(1), 0, 'filled','SizeData',100);
hold on;
scatter(data(2), 1./data(5),'filled','SizeData',100);
scatter(data(3), 1./data(6),'filled','SizeData',100);
hold off;
labels = ["Zero", "Low", "High"];

% 그래프 타이틀, x축 라벨, y축 라벨 추가
title('Zero vs. Low vs. High');
xlabel(labels);
ylabel('Hz');


%%

x = [data(1), data(2), data(3)];
y = [0, 1./data(5), 1./data(6)];
labels = ["Zero", "Low", "High"];

title('Zero vs. Low vs. High');
xlabel(labels);
ylabel('Hz');

plot(x, y, '-o', 'MarkerSize', 10);

for i = 1:length(labels)
    text(x(i)+i, -10, labels(i), 'HorizontalAlignment', 'center');
end


