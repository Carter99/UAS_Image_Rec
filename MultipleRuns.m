results=[];
correctResults=[];
for Learning_Rate=[0.1,0.05,0.01,0.005,0.001,0.0005,0.0001]
    UAS_NN_V4_Training
    results(end+1)=partialRunResult;
    correctResults(end+1,:)=partialRunCorrect;
end
disp(results')
plot(correctResults')