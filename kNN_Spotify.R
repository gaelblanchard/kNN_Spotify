library(e1071)
library(RWeka)
library(dplyr)
library(caret)
setwd("/directory/k_Nearest_Neighbors_R")
set.seed(0)
top_100_songs <- data.frame(read.csv("top_100_2017.csv", header = TRUE, sep = ","))
songs_2017 <- data.frame(read.csv("songs_2017.csv", header = TRUE, sep = ","))
names(top_100_songs) <- c("id","song_title","artists","danceability","energy","key","loudness","mode","speechiness","acousticness","instrumentalness","liveness","valence","tempo","duration_ms","time_signature")
names(songs_2017) <- c("index","acousticness","danceability","duration_ms","energy","instrumentalness","key","liveness","loudness","mode","speechiness","tempo","time_signature","valence","target","song_title","artists")
top_100_songs <- top_100_songs[2:16]
songs_2017 <- songs_2017[2:17]
songs_2017$is_top_100 <- ifelse((songs_2017$song_title %in% top_100_songs$song_title),'Y','N')
top_100_songs$is_top_100 <- 'Y'
top_100_songs <- top_100_songs[!(top_100_songs$song_title %in% songs_2017$song_title),]
songs_2017$target <- NULL
new_songs <- rbind(songs_2017, top_100_songs)
subset_new_songs <- subset(new_songs, select=c(
				is_top_100,
				acousticness,
				danceability,
				duration_ms,
				energy,
				instrumentalness,
				key,
				liveness,
				loudness,
				mode,
				speechiness,
				tempo,
				time_signature,
				valence
				)
			)
sum_acousticness <- sum(new_songs$acousticness)
sum_danceability <- sum(new_songs$danceability)
sum_duration_ms <- sum(new_songs$duration_ms)
sum_energy <- sum(new_songs$energy) 
sum_instrumentalness <- sum(new_songs$instrumentalness)
sum_key <- sum(new_songs$key)
sum_liveness <- sum(new_songs$liveness) 
sum_loudness <- sum(new_songs$loudness)
sum_mode <- sum(new_songs$mode)
sum_speechiness <- sum(new_songs$speechiness)
sum_tempo <- sum(new_songs$tempo)
sum_time_signature <- sum(new_songs$time_signature)
sum_valence <- sum(new_songs$valence) 
new_songs$acousticness <- new_songs$acousticness/sum_acousticness
new_songs$danceability <- new_songs$danceability/sum_danceability
new_songs$duration_ms <- new_songs$duration_ms/sum_duration_ms
new_songs$energy <- new_songs$energy/sum_energy
new_songs$instrumentalness <- new_songs$instrumentalness/sum_instrumentalness
new_songs$key <- new_songs$key/sum_key
new_songs$liveness <- new_songs$liveness/sum_liveness
new_songs$loudness <- new_songs$loudness/sum_loudness
new_songs$mode <- new_songs$mode/sum_mode
new_songs$speechiness <- new_songs$speechiness/sum_speechiness
new_songs$tempo <- new_songs$tempo/sum_tempo
new_songs$time_signature <- new_songs$time_signature/sum_time_signature
new_songs$valence <- new_songs$valence/sum_valence
write.csv(new_songs, file = "table_songs.csv")
cor(new_songs)
new_songs_cor <- round(cor(new_songs), 1)
songs_norm <- subset(new_songs,select=c("is_top_100","danceability","speechiness","valence"))
data.samples <- sample(1:nrow(songs_norm),nrow(songs_norm) * 0.7, replace = FALSE)
training.data <- songs_norm[data.samples, ]
test.data <- songs_norm[-data.samples, ]

#KNN
#On training data
training.data$is_top_100 <- as.factor(training.data$is_top_100)
classifier <- IBk(is_top_100 ~., data = training.data, control = Weka_control(K = 2, X = TRUE))
evaluate_Weka_classifier(classifier, numFolds = 10)
table(training.data$is_top_100, classifier$predictions)
confusionMatrix(classifier$predictions, training.data$is_top_100)
#On testing data
test.data$is_top_100 <- as.factor(test.data$is_top_100)
classifier <- IBk(is_top_100 ~., data = test.data, control = Weka_control(K = 2, X = TRUE))
evaluate_Weka_classifier(classifier, numFolds = 10)
table(test.data$is_top_100, classifier$predictions)
confusionMatrix(classifier$predictions, test.data$is_top_100)
#On total data set
songs_norm$is_top_100 <- as.factor(songs_norm$is_top_100)
classifier <- IBk(is_top_100 ~., data = songs_norm, control = Weka_control(K = 2, X = TRUE))
evaluate_Weka_classifier(classifier, numFolds = 10)
table(songs_norm$is_top_100, classifier$predictions)
confusionMatrix(classifier$predictions, songs_norm$is_top_100)