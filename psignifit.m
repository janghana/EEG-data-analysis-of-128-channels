% 데이터셋을 불러옵니다.
data = load('./jumping_data/Jumping_30.10_cjh_Mar.20.2023 15.57.29.mat');

% 모델을 정의합니다.
model = @PAL_Logistic;

% 모델 파라미터 초기값을 설정합니다.
paramsValues = [0 1 0.01 0];

% 파라미터 범위를 설정합니다.
paramsFree = [1 1 1 1];
options = PAL_minimize('options');
options.TolFun = 1e-09;
options.MaxIter = 10000;

% 데이터셋을 fitting합니다.
[paramsValues, LL, exitflag, output] = PAL_PFML_Fit(data.x, data.y, data.n, paramsValues, paramsFree, model, 'SearchOptions', options);

% 결과를 출력합니다.
fprintf('Threshold estimate: %f\n', paramsValues(1));
fprintf('Slope estimate: %f\n', paramsValues(2));
