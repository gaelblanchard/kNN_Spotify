import numpy as np
import pandas as pd
import seaborn as sb
import matplotlib.pyplot as plt
import sklearn
from sklearn.naive_bayes import GaussianNB
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import train_test_split

def print_results(predictions,data,desired_variable):
	print("Results:")
	print("Number of mislabeled points out of a total {} points : {}, performance {:05.2f}%"
	.format(
		test_data.shape[0],
		(data[desired_variable] != predictions).sum(),
		100*(1-(data[desired_variable] != predictions).sum()/data.shape[0])
		)
	)

np.random.seed(0)
songs_data = pd.read_csv("table_songs.csv", encoding = "ISO-8859-1")
factors_list = ["is_top_100","danceability","speechiness","valence"]
predictor_factors = ["danceability","speechiness","valence"]

#kNN
#subset to change our cancer_data to train our statistical model
#id diagnosis radius worst perimeter worst area worst concave points worst
#in RWeka i was easilt able to use IBK function
#Used 10 k nearest neighbors for classification 
songs_data_norm = songs_data[factors_list]
data_sample = songs_data_norm.sample(frac=0.7, replace=False)
training_data = data_sample
test_data = songs_data_norm[~songs_data_norm.isin(training_data)].dropna()
knn_model = KNeighborsClassifier(n_neighbors=2)
knn_model.fit(training_data[predictor_factors],training_data["is_top_100"])
test_pred = knn_model.predict(test_data[predictor_factors])
print_results(test_pred,test_data,"is_top_100")