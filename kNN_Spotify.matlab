SongData = readtable('table_songs.csv')
varNames = {'danceability','speechiness','valence'}
IsTopHundred = SongData.is_top_100
PredictorVariables = SongData(:,varNames)

%kNN Model
kNNIsTopHundred = fitcknn(PredictorVariables,IsTopHundred,'NSMethod','exhaustive','Distance','cosine','NumNeighbors',2)
kNNResubError = resubLoss(kNNIsTopHundred)
% 5 percent miscalulation 95 percent
PredValue = predict(kNNIsTopHundred,SongData(:,varNames))
kNNConfMat = confusionmat(IsTopHundred,PredValue)
CVkNNModel = crossval(kNNIsTopHundred)
% 9 percent miscaulation
kNNLossModel = kfoldLoss(CVkNNModel)