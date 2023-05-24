% �����ͼ��� �ҷ��ɴϴ�.
data = load('./jumping_data/Jumping_30.10_cjh_Mar.20.2023 15.57.29.mat');

% ���� �����մϴ�.
model = @PAL_Logistic;

% �� �Ķ���� �ʱⰪ�� �����մϴ�.
paramsValues = [0 1 0.01 0];

% �Ķ���� ������ �����մϴ�.
paramsFree = [1 1 1 1];
options = PAL_minimize('options');
options.TolFun = 1e-09;
options.MaxIter = 10000;

% �����ͼ��� fitting�մϴ�.
[paramsValues, LL, exitflag, output] = PAL_PFML_Fit(data.x, data.y, data.n, paramsValues, paramsFree, model, 'SearchOptions', options);

% ����� ����մϴ�.
fprintf('Threshold estimate: %f\n', paramsValues(1));
fprintf('Slope estimate: %f\n', paramsValues(2));
