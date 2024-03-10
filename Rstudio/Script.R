install.packages("remotes")
library(remotes)

# install GitHub version of vosonSML 0.32.10
install_github("vosonlab/vosonSML")

# install GitHub version of rtweet 1.1.0.9001
install_github("ropensci/rtweet")


# Load packages required for this session into library

library(vosonSML)
library(magrittr)
library(igraph)
library(tidyr)
library(tidytext)
library(stopwords)


# Set up Twitter authentication variables

my_app_name <- ""
my_api_key <- ""
my_api_secret <- ""
my_access_token <- ""
my_access_token_secret <- ""

##QUESTION 1.2

# Authenticate to Twitter and collect data

twitter_data <- Authenticate("twitter",
                             appName = my_app_name,
                             apiKey = my_api_key,
                             apiSecret = my_api_secret,
                             accessToken = my_access_token,
                             accessTokenSecret = my_access_token_secret) %>%
  Collect(searchTerm = "#Eminem",
          searchType = "recent",
          numTweets = 1500,
          lang = "en",
          includeRetweets = TRUE,
          writeToFile = TRUE,
          verbose = TRUE) # use 'verbose' to show download progress


# View collected Twitter data

View(twitter_data$tweets)


##QUESTION 1.3

# Create actor network and graph from the data

twitter_actor_network <- twitter_data %>% Create("actor")
twitter_actor_graph <- twitter_actor_network %>% Graph()


# Write graph to file
# Make sure to set your working directory to where you want to save the file
# before you execute the next line

write.graph(twitter_actor_graph, file = "TwitterActor.graphml", format = "graphml")


# Overwrite the 'name' attribute in your graph with the 'screen name' attribute
# to replace twitter IDs with more meaningful names,
# Run Page Rank algorithm to find important users

V(twitter_actor_graph)$name <- V(twitter_actor_graph)$screen_name

rank_twitter_actor <- sort(page_rank(twitter_actor_graph)$vector, decreasing = TRUE)

#show top 5
head(rank_twitter_actor, n = 5)


##QUESTION 1.4

# Create semantic network and graph from the data

twitter_semantic_network <- twitter_data %>% Create("semantic")

twitter_semantic_graph <- twitter_semantic_network %>% Graph()


# Write graph to file

write.graph(twitter_semantic_graph, file = "TwitterSemantic.graphml", format = "graphml")


# Run Page Rank algorithm to find important terms/hashtags

rank_twitter_semantic <- sort(page_rank(twitter_semantic_graph)$vector, decreasing = TRUE)

#show top 10

head(rank_twitter_semantic, n = 10)


# Create the network and graph again, but this time:
# - with 25% of the most frequent terms (before was the default of 5%)
# - with 75% of the most frequent hashtags (before was the default of 50%)
# - removing the actual search term ("#Eminem")

tw_sem_nw_more_terms <- twitter_data %>%
  Create("semantic",
         termFreq = 25,
         hashtagFreq = 75,
         removeTermsOrHashtags = c("#Eminem"))

tw_sem_graph_more_terms <- tw_sem_nw_more_terms %>% Graph()


# Write graph to file

write.graph(tw_sem_graph_more_terms,
            file = "TwitterSemanticMoreTerms.graphml",
            format = "graphml")


# Run Page Rank algorithm to find important terms/hashtags

rank_tw_sem_nw_more_terms <- sort(page_rank(tw_sem_graph_more_terms)$vector, decreasing = TRUE)

#show top 10

head(rank_tw_sem_nw_more_terms, n = 10)

##QUESTION 1.5
#screen name to users
num_users <- nrow(unique(twitter_data$screen_name))

# Creates data frame
eminem_User_df <- data.frame(twitter_data)
View(eminem_User_df)

#find unique users in data frame
unique(eminem_User_df$users.id)
unique_users <- unique(eminem_User_df$users.id)

#count unique users using lenght function
num_unique_users <- length(unique_users)
num_unique_users


#Answer2.1
# Part 1: Spotify artist analysis for Eminem----

# Load packages required for this session into library

library(Rspotify)
library(spotifyr)
library(magrittr)
library(igraph)
library(dplyr)
library(knitr)
library(ggplot2)
library(ggridges)
library(httpuv)


# Configure application to store Spotify authentication data in cache

options(httr_oauth_cache = TRUE)


# Set up authentication variables

app_id <- ""
app_secret <- ""
token <- "1"


# Authentication for Rspotify package:

keys <- spotifyOAuth(token, app_id, app_secret)


# Get Spotify data on 'Eminem'

find_my_artist <- searchArtist("Eminem", token = keys)
View(find_my_artist)


# Retrieve information about artist

my_artist <- getArtist("7dGJo4pcD2V6oG8kP0tJRR", token = keys)
View(my_artist)


# Retrieve album data of artist

albums <- getAlbums("7dGJo4pcD2V6oG8kP0tJRR", token = keys)
View(albums)


#Top Songs by Eminem

eminem_top_tracks <- get_artist_top_tracks("7dGJo4pcD2V6oG8kP0tJRR")
View(eminem_top_tracks)
eminem_toptracks <- eminem_top_tracks$name
eminem_toptracks

song <- getAlbum("10nO3EJJDMm6j6d2uK3Jah", token = keys)
View(song)


# Retrieve song data

song <- getFeatures("1IiOIBsOQrQvcge0HiwF90", token = keys)
View(song)

# Authentication for spotifyr package:

Sys.setenv(SPOTIFY_CLIENT_ID = app_id)
Sys.setenv(SPOTIFY_CLIENT_SECRET = app_secret)
access_token <- get_spotify_access_token()


# Get audio features for 'Eminem'

audio_features <- get_artist_audio_features("Eminem")
View(audio_features)

#remove duplicates

audio_features <- audio_features[!duplicated(audio_features$track_name), ]

#Active Years
earliest_release <- min(audio_features$album_release_date)
current_year <- as.numeric(format(Sys.Date(), "%Y"))
active_years <- current_year - as.numeric(substr(earliest_release, 1, 4))
active_years

# Total number of songs
num_albums <- length(audio_features$album_id)
num_songs <- length(audio_features$track_id)
num_albums
num_songs

# To see Eminem collaborations with other singers:
View(audio_features[, c("artist_name", "track_name")])

# Plot energy scores for each album
ggplot(audio_features, aes(x = energy, y = album_name)) +
  geom_density_ridges() +
  theme_ridges() +
  ggtitle("energy in Eminem Albums",
          subtitle = "Based on energy from Spotify's Web API")

# Plot loudness
ggplot(audio_features, aes(x = loudness, y = album_name)) +
  geom_density_ridges() +
  theme_ridges() +
  ggtitle("loudness in Eminem Albums",
          subtitle = "Based on loudness from Spotify's Web API")

# Plot speechiness
ggplot(audio_features, aes(x = speechiness, y = album_name)) +
  geom_density_ridges() +
  theme_ridges() +
  ggtitle("speechiness in Eminem Albums",
          subtitle = "Based on speechiness from Spotify's Web API")

# Retrieve information about related artists

related_eminem <- getRelated("Eminem", token = keys)
View(related_eminem)

# Create a network of artists related to the Top 100 artists

topsongs <- getPlaylistSongs("spotify", "4hOKQuZbraPDIfaGbM3lKI", token = keys)


edges <- c()
for (artist in topsongs$artist){
  related <- getRelated(artist, token = keys)
  for (relatedartist in related$name){
    edges <- append(edges, artist)
    edges <- append(edges, relatedartist)
  }
}

# Convert network to graph and save as external file

related_artists_graph <- graph(edges)
write.graph(related_artists_graph, file = "RelatedArtists.graphml", format = "graphml")

#---------------------------------------------------
#2.2  
##Youtube API Eminem

# Load packages required for this session into library
library(tuber)
library(vosonSML)
library(magrittr)
library(igraph)
library(httpuv)


# Set up YouTube authentication variables 

api_key <- ""
client_id <- ""
client_secret <- ""


# Authenticate to YouTube using the tuber package

yt_oauth(app_id = client_id, app_secret = client_secret, token = '1')

# Search YouTube

video_search <- yt_search("Eminem")
View(video_search)


# Pick a video from video_search and get some info 

get_stats(video_id = "YVkUvmDQ3HY")
get_stats(video_id = "S9bCLPwzSC0")
get_stats(video_id = "8CdcCD5V-d8")
get_stats(video_id = "RjrA-slMoZ4")
get_stats(video_id = "gOMhN-hfMtY")

# Choose some videos and store their video IDs,
# for which we want to collect comments
# and build an actor network

video_ids <- as.vector(video_search$video_id[1:10])

yt_data <- Authenticate("youtube", apiKey = api_key) %>%
  Collect(videoIDs = video_ids,
          writeToFile = TRUE,
          maxComments = 500,
          verbose = TRUE)

View(yt_data)

yt_actor_network <- yt_data %>% Create("actor")
yt_actor_graph <- Graph(yt_actor_network)


#---------------------------------------------------

#2.3
# Part 3: Text pre-processing for twitter Data

# Load packages required for this session into library

library(vosonSML)
library(magrittr)
library(tidyr)
library(tidytext)
library(stopwords)
library(textclean)
library(qdapRegex)
library(tm)
library(SnowballC)
library(ggplot2)


# Set up Twitter authentication variables

my_app_name <- ""
my_api_key <- ""
my_api_secret <- ""
my_access_token <- ""
my_access_token_secret <- ""


# Authenticate to Twitter and collect data

twitter_data <- Authenticate("twitter",
                             appName = my_app_name,
                             apiKey = my_api_key,
                             apiSecret = my_api_secret,
                             accessToken = my_access_token,
                             accessTokenSecret = my_access_token_secret) %>%
  Collect(searchTerm = "Eminem",
          searchType = "recent",
          numTweets = 1000,
          lang = "en",
          includeRetweets = TRUE,
          writeToFile = TRUE,
          verbose = TRUE) # use 'verbose' to show download progress

#load twitter data
load("/Users/Aanuj/Desktop/griffith/Bigdata/AnujKhurana_Milestone1/Rstudio/Milestone1.RData")
#tweet data to json for visualization
library('jsonlite')
TwitterData_eminem <- readRDS ("/Users/Aanuj/Desktop/griffith/Bigdata/AnujKhurana_Milestone1/Rstudio/eminem.rds")
json_TwitterData_eminem <- toJSON(TwitterData_eminem)
write (json_TwitterData_eminem, file = "TwitterData_eminem.json")

TwitterData_adele <- readRDS ("/Users/Aanuj/Desktop/griffith/Bigdata/Milestone2/Adele.rds")
json_TwitterData_eminem <- toJSON(TwitterData_adele)
write (json_TwitterData_eminem, file = "TwitterData_adele.json")

# Clean the tweet text

clean_text <- twitter_data$tweets$text %>% 
  rm_twitter_url() %>% 
  replace_url() %>% 
  replace_hash() %>% 
  replace_tag() %>% 
  replace_emoji() %>% 
  replace_emoticon()


# Convert clean_text vector into a document corpus (collection of documents)

text_corpus <- VCorpus(VectorSource(clean_text))

text_corpus[[1]]$content
text_corpus[[5]]$content


# Perform further pre-processing 

text_corpus <- text_corpus %>%
  tm_map(content_transformer(tolower)) %>% 
  tm_map(removeNumbers) %>% 
  tm_map(removePunctuation) %>% 
  tm_map(removeWords, stopwords(kind = "SMART")) %>% 
  tm_map(stemDocument) %>% 
  tm_map(stripWhitespace)

text_corpus[[1]]$content
text_corpus[[5]]$content


# Transform corpus into a Document Term Matrix

doc_term_matrix <- DocumentTermMatrix(text_corpus)


# Sort words by total frequency across all documents

dtm_df <- as.data.frame(as.matrix(doc_term_matrix))
View(dtm_df)

freq <- sort(colSums(dtm_df), decreasing = TRUE)

head(freq, n = 10)


# Plot word frequency

word_frequ_df <- data.frame(word = names(freq), freq)
View(word_frequ_df)
head(word_frequ_df, n = 10)

ggplot(subset(word_frequ_df, freq > 2), aes(x = reorder(word, -freq), y = freq)) +
  geom_bar(stat = "identity") + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Word Frequency") + 
  xlab("Words") + 
  ylab("Frequency")

ggplot(subset(word_frequ_df, freq > 67), aes(x = reorder(word, -freq), y = freq)) +
  geom_bar(stat = "identity") + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Word Frequency") + 
  xlab("Words") + 
  ylab("Frequency")

#---------------------------------------------------------
#2.4

# Part 4: Centrality Analysis ----

# Load packages required for this session into library

library(vosonSML)
library(magrittr)
library(tidytext)
library(igraph)

# Create twomode (bimodal) network

twomode_network <- twitter_data %>% Create("twomode", 
                                           removeTermsOrHashtags = c("#eminem"))
twomode_graph <- twomode_network %>% Graph()


# Write graph to file

write.graph(twomode_graph, file = "TwitterTwomode.graphml", format = "graphml")


# Inspect the graph object

length(V(twomode_graph))
V(twomode_graph)$name


# Find all maximum components that are weakly connected

twomode_comps <- components(twomode_graph, mode = c("weak"))

twomode_comps$no
twomode_comps$csize
head(twomode_comps$membership, n = 30)


# Get sub-graph with most members

largest_comp <- which.max(twomode_comps$csize)

twomode_subgraph <- twomode_graph %>% 
  induced_subgraph(vids = which(twomode_comps$membership == largest_comp))


# Display top 20 nodes from the sub-graph ordered by degree centrality

sort(degree(twomode_subgraph, mode = "in"), decreasing = TRUE)[1:20]
sort(degree(twomode_subgraph, mode = "out"), decreasing = TRUE)[1:20]
sort(degree(twomode_subgraph, mode = "total"), decreasing = TRUE)[1:20]


# Display top 20 nodes from the sub-graph ordered by closeness centrality

sort(closeness(twomode_subgraph, mode = "in"), decreasing = TRUE)[1:20]
sort(closeness(twomode_subgraph, mode = "out"), decreasing = TRUE)[1:20]
sort(closeness(twomode_subgraph, mode = "total"), decreasing = TRUE)[1:20]


# Display top 20 nodes from the sub-graph ordered by betweenness centrality

sort(betweenness(twomode_subgraph, directed = FALSE), decreasing = TRUE)[1:20]

#---------------------------------------------------------

# 2.5 community analysis with the Girvan-Newman (edge betweenness) and Louvain methods

# Load packages required for this session into library

library(tuber)
library(vosonSML)
library(magrittr)
library(igraph)
library(httpuv)

# Search YouTube

video_search <- yt_search("wminwm")
View(video_search)

# Choose some videos and store their video IDs,
# for which we want to collect comments
# and build an actor network

video_ids <- as.vector(video_search$video_id[1:10])

yt_data <- Authenticate("youtube", apiKey = api_key) %>%
  Collect(videoIDs = video_ids,
          writeToFile = TRUE,
          maxComments = 500,
          verbose = TRUE)

View(yt_data)

yt_actor_network <- yt_data %>% Create("actor")
yt_actor_graph <- Graph(yt_actor_network)

# Transform into an undirected graph

undir_yt_actor_graph <- as.undirected(yt_actor_graph, mode = "collapse")

# Run Louvain algorithm

louvain_yt_actor <- cluster_louvain(undir_yt_actor_graph)


# See sizes of communities

sizes(louvain_yt_actor)


# Visualise the Louvain communities

plot(louvain_yt_actor, 
     undir_yt_actor_graph, 
     vertex.label = V(undir_yt_actor_graph)$screen_name,
     vertex.size = 4,
     vertex.label.cex = 0.7)


# Run Girvan-Newman (edge-betweenness) algorithm

eb_yt_actor <- cluster_edge_betweenness(undir_yt_actor_graph)


# See sizes of communities

sizes(eb_yt_actor)


# Visualise the edge-betweenness communities

plot(eb_yt_actor,
     undir_yt_actor_graph, 
     vertex.label = V(undir_yt_actor_graph)$screen_name,
     vertex.size = 4,
     vertex.label.cex = 0.7)


# Visualise the edge-betweenness hierarchy

yt_actor_graph2 <- yt_actor_graph
V(yt_actor_graph2)$name <- V(yt_actor_graph2)$screen_name
undir_yt_actor_graph2 <- as.undirected(yt_actor_graph2, mode = "collapse")
eb_yt_actor2 <- cluster_edge_betweenness(undir_yt_actor_graph2)

is_hierarchical(eb_yt_actor2)
as.dendrogram(eb_yt_actor2)
plot_dendrogram(eb_yt_actor2)

plot_dendrogram(eb_yt_actor2, mode = "dendrogram", xlim = c(1,20))


#---------------------------------------------------------

#2.6 Sentiment Analysis

# Load packages required for this session into library

library(vosonSML)
library(magrittr)
library(tidytext)
library(textclean)
library(qdapRegex)
library(syuzhet)
library(ggplot2)

# Clean the tweet text

clean_text <- twitter_data$tweets$text  %>% 
  rm_twitter_url() %>% 
  replace_url() %>% 
  replace_hash() %>% 
  replace_tag() %>% 
  replace_internet_slang() %>% 
  replace_emoji() %>% 
  replace_emoticon() %>% 
  replace_non_ascii() %>% 
  replace_contraction() %>% 
  gsub("[[:punct:]]", " ", .) %>% 
  gsub("[[:digit:]]", " ", .) %>% 
  gsub("[[:cntrl:]]", " ", .) %>% 
  gsub("\\s+", " ", .) %>% 
  tolower()


# Assign sentiment scores to tweets

sentiment_scores <- get_sentiment(clean_text, method = "afinn") %>% sign()

sentiment_df <- data.frame(text = clean_text, sentiment = sentiment_scores)
View(sentiment_df)


# Convert sentiment scores to labels: positive, neutral, negative

sentiment_df$sentiment <- factor(sentiment_df$sentiment, levels = c(1, 0, -1),
                                 labels = c("Positive", "Neutral", "Negative")) 
View(sentiment_df)


# Plot sentiment classification

ggplot(sentiment_df, aes(x = sentiment)) +
  geom_bar(aes(fill = sentiment)) +
  scale_fill_brewer(palette = "RdGy") +
  labs(fill = "Sentiment") +
  labs(x = "Sentiment Categories", y = "Number of Tweets") +
  ggtitle("Sentiment Analysis of Tweets")


# Assign emotion scores to tweets

emo_scores <- get_nrc_sentiment(clean_text)[ , 1:8]

emo_scores_df <- data.frame(clean_text, emo_scores)
View(emo_scores_df)


# Calculate proportion of emotions across all tweets

emo_sums <- emo_scores_df[,2:9] %>% 
  sign() %>% 
  colSums() %>% 
  sort(decreasing = TRUE) %>% 
  data.frame() / nrow(emo_scores_df) 

names(emo_sums)[1] <- "Proportion" 
View(emo_sums)


# Plot emotion classification

ggplot(emo_sums, aes(x = reorder(rownames(emo_sums), Proportion),
                     y = Proportion,
                     fill = rownames(emo_sums))) +
  geom_col() +
  coord_flip()+
  guides(fill = "none") +
  scale_fill_brewer(palette = "Dark2") +
  labs(x = "Emotion Categories", y = "Proportion of Tweets") +
  ggtitle("Emotion Analysis of Tweets")

#--------------------------------
#2.7 
# Decision Tree 

library(spotifyr)
library(C50)
library(caret)
library(e1071)
library(dplyr)

# Get songs from eminem and their audio features

eminem_features <- get_artist_audio_features("eminem")
View(eminem_features)

data.frame(colnames(eminem_features))

eminem_features_subset <- eminem_features[ , 9:20]
View(eminem_features_subset)


# Get top 100 songs and their audio features

top100_features <- get_playlist_audio_features("spotify", "4hOKQuZbraPDIfaGbM3lKI")
View(top100_features)

data.frame(colnames(top100_features))

top100_features_subset <- top100_features[ , 6:17]
View(top100_features_subset)

top100_features_subset <- top100_features_subset %>% rename(track_id = track.id)


# Add the 'isladygaga' column (class variable) to each data frame
# to indicate which songs are by ladygaga and which are not

top100_features_subset["isEminem"] <- 0
Eminem_features_subset["isEminem"] <- 1


# Remove any songs by ladygaga that appear in the top 100
# and combine the two data frames into one dataset

top100_features_no_eminem <- anti_join(top100_features_subset,
                                       eminem_features_subset,
                                         by = "track_id")
comb_data <- rbind(top100_features_no_eminem, eminem_features_subset)


# Format the dataset so that we can give it as input to a model:
# change the 'isEminem' column into a factor
# and remove the 'track_id' column

comb_data$isEminem <- factor(comb_data$isEminem)
comb_data <- select(comb_data, -track_id)


# Randomise the dataset (shuffle the rows)

comb_data <- comb_data[sample(1:nrow(comb_data)), ]


# Split the dataset into training and testing sets (80% training, 20% testing)

split_point <- as.integer(nrow(comb_data)*0.8)
training_set <- comb_data[1:split_point, ]
testing_set <- comb_data[(split_point + 1):nrow(comb_data), ]


# Train the decision tree model

dt_model <- train(isladygaga~ ., data = training_set, method = "C5.0")


# Sample a single prediction (can repeat)

prediction_row <- 4 # MUST be smaller than or equal to training set size

if (tibble(predict(dt_model, testing_set[prediction_row, ])) ==
    testing_set[prediction_row, 12]){
  print("Prediction is correct!")
} else {
  ("Prediction is wrong")
}


# Analyse the model accuracy with a confusion matrix

confusionMatrix(dt_model, reference = testing_set$isEminem)


#---------------------------------
#2.8 LDA topic modelling 
#lab 5.1
  
# Load packages required for this part
  
library(vosonSML)
library(magrittr)
library(tidytext)
library(textclean)
library(qdapRegex)
library(tm)
library(topicmodels)
library(slam)
library(Rmpfr)
library(dplyr)
library(ggplot2)
library(reshape2)

# Clean the tweet text

clean_text <- twitter_data$tweets$text  %>% 
  rm_twitter_url() %>% 
  replace_url() %>% 
  replace_hash() %>% 
  replace_tag() %>% 
  replace_internet_slang() %>% 
  replace_emoji() %>% 
  replace_emoticon() %>% 
  replace_non_ascii() %>% 
  replace_contraction() %>% 
  gsub("[[:punct:]]", " ", .) %>% 
  gsub("[[:digit:]]", " ", .) %>% 
  gsub("[[:cntrl:]]", " ", .) %>% 
  gsub("\\s+", " ", .) %>% 
  tolower()


# Convert clean tweet vector into a document corpus (collection of documents)

text_corpus <- VCorpus(VectorSource(clean_text))

text_corpus[[1]]$content
text_corpus[[5]]$content


# Remove stop words

text_corpus <- text_corpus %>%
  tm_map(removeWords, stopwords(kind = "SMART")) 

text_corpus[[1]]$content
text_corpus[[5]]$content


# Transform corpus into a Document Term Matrix and remove 0 entries

doc_term_matrix <- DocumentTermMatrix(text_corpus)
non_zero_entries = unique(doc_term_matrix$i)
dtm = doc_term_matrix[non_zero_entries,]


# Optional: Remove objects and run garbage collection for faster processing

save(dtm, file = "doc_term_matrix.RData")
rm(list = ls(all.names = TRUE))
gc() 
load("doc_term_matrix.RData")


# Create LDA model with k topics

lda_model <- LDA(dtm, k = 6)


# Generate topic probabilities for each word
# 'beta' shows the probability that this word was generated by that topic

tweet_topics <- tidy(lda_model, matrix = "beta")


# Visualise the top 10 terms per topic

top_terms <- tweet_topics %>%
  group_by(topic) %>%
  slice_max(beta, n = 10) %>% 
  ungroup() %>%
  arrange(topic, -beta)

top_terms %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(beta, term, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered()

#------------------------------------------


