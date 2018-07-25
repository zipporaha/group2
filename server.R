library(shiny)
library(shinydashboard)
library(tm)
library(XML)
library(ggplot2)
library(plyr)
library(dplyr)
library(stringr)
library(syuzhet)
library(SnowballC)
library(RColorBrewer)
library(shinythemes)
library(wordcloud)
library(lubridate)
library(anytime)



shinyServer(function(input, output, session){
  
output$about <- renderText({})
  

 myfile <- reactive({
   
   if(is.null(input$file)){
     return()
   }
    mystore <- read.csv(file = input$file$datapath,  T, ",")
    mystore
    
    
 })
 #wordcloud
 output$wordcloud <- renderPlot({
   #Cleaning
   mydataset = gsub("[[:punct:]]", "", myfile()$Chat.content)
   mydataset = gsub("[[:punct:]]", "", mydataset)
   mydataset = gsub("[[:digit:]]", "", mydataset)
   mydataset = gsub("http\\w+", "", mydataset)
   mydataset = gsub("[ \t]{2,}", "", mydataset)
   mydataset = gsub("^\\s+|\\s+$", "", mydataset)
   words <- tm_map(words, removeWords,c("this","can","will","one","what","when","with","you","daina","akurut","hello","the"))
   
 wordcloud(mydataset, min.freq = input$wd, max.words = input$wcloud,   colors = brewer.pal(8,"Set2"), random.order = F )
 
 #download /wordcloud
 
  })
 
  
 #SentimentAnalysis
 output$sentiment <- renderPlot({
   
   #Cleaning
   mydataset = gsub("[[:punct:]]", "", myfile()$Chat.content)
   mydataset = gsub("[[:punct:]]", "", mydataset)
   mydataset = gsub("[[:digit:]]", "", mydataset)
   mydataset = gsub("http\\w+", "", mydataset)
   mydataset = gsub("[ \t]{2,}", "", mydataset)
   mydataset = gsub("^\\s+|\\s+$", "", mydataset)
   
   
   sentianalysis <- get_nrc_sentiment(mydataset[1:10])
   sentimentscores <- data.frame(colSums(sentianalysis[,]))
   names(sentimentscores) <- "Score"
   sentimentscores <- cbind("sentiment" = rownames(sentimentscores), sentimentscores)
   rownames(sentimentscores) <- NULL
   ggplot(sentimentscores, aes(x = sentiment, y = Score)) +
     geom_bar(aes(fill = sentiment), stat = "identity") + 
     theme(legend.position = "none") +
     xlab("Emotions and Polarity") +
     ylab("Sentiment Score") + 
     ggtitle("Classificattion based on both emotion and polarity")
   
   
 })
 
 

 #Text Mining 
 output$text <- renderPlot({
   
   #Cleaning
   mydataset = gsub("[[:punct:]]", "", myfile()$Chat.content)
   mydataset = gsub("[[:punct:]]", "", mydataset)
   mydataset = gsub("[[:digit:]]", "", mydataset)
   mydataset = gsub("http\\w+", "", mydataset)
   textdata = gsub("[ \t]{2,}", "", mydataset)
   mydataset = gsub("^\\s+|\\s+$", "", mydataset)
   #View(mydataset)
   
   
   mydataset <- gettext(file$Chat.content)
   #View(mydataset)
   
   
   # Characters per email
   characters_per_email <- nchar(mydataset)
   summary(characters_per_email)
   
   sapply(file$Chat.content, function(x) max(nchar(x)))
   
   
   # Split words
   words_list = strsplit(file$Chat.content, " ")
   
   # Words per email 
   words_per_email = sapply(words_list, length)
   View(words_per_email)
   barplot(table(words_per_email),   main="Distribution of words per chat", cex.main=1, axes = T)
   
   # How long is the typical email?
   max(words_per_email)
   
   
   #	How does email length differ by rating?
   data <- cbind(words_per_email, file)
   
   
   # Length of words per email
   word_length = sapply(words_list, function(x) mean(nchar(x)))
   barplot(table(round(word_length)), border=NA,xlab = "Word length in number of characters", ylab= "Chats",main="Distribution of words length per email", cex.main=1)
   
   
 })
 
 #BarPlot1
 output$barPlot <- renderPlot({
   
   mydatasetcorpus <- Corpus(VectorSource(myfile()$Chat.content))
   
   #corpus cleaning
   cleancorpus <- tm_map(mydatasetcorpus, stripWhitespace)
   #inspect(cleancorpus[1:10])
   
   cleancorpus <- tm_map(mydatasetcorpus, removePunctuation)
   #inspect(cleancorpus[1:10])
   
   cleancorpus <- tm_map(mydatasetcorpus, PlainTextDocument)
   
   cleancorpus <- tm_map(mydatasetcorpus, removeNumbers)
   
   cleancorpus <- tm_map(mydatasetcorpus, removeWords, stopwords("english"))
   
   cleancorpus <- tm_map(mydatasetcorpus, content_transformer(tolower))
   #inspect(cleancorpus[1:10])
   
   #cleancorpus <- tm_map(mydatasetcorpus, removeWords, c("this", "part","the","they","and","was","for","there"))
   
   #wordcloud(cleancorpus, min.freq = 5, colors = brewer.pal(9,"Set2"), random.order = F)
   
   
   dtm <- TermDocumentMatrix(mydatasetcorpus[1:100], control = list(removeNumbers = T, removePunctuation = T, stripWhitespace = T, tolower = T, stopwords = T, stemming = T))
   findFreqTerms(dtm, lowfreq = 15)
   termFrequency <- rowSums(as.matrix(dtm))
   #termFrequency[1:50]
   termFrequency <- subset(termFrequency, termFrequency >=15)
   barplot(termFrequency, las = 2, col = rainbow(20),main = "Bar plot showing mostly used words", xlab = "Words", ylab = "Frequency")
   
   
 })
 
 #BarPlot2
 output$barplot <- renderPlot({
   
   mydatasetcorpus <- Corpus(VectorSource(mydataset$Country))
   dtm <- TermDocumentMatrix(mydatasetcorpus, control = list(removeNumbers = T, removePunctuation = T, stripWhitespace = T))
   termFrequency <- rowSums(as.matrix(dtm))
   barplot(termFrequency, las = 2, col = rainbow(20),main = "Bar plot showing participation of the different countries", xlab = "countries", ylab = "participation")
   
   
 })


 
 
 
 
 #emails per hour
output$emails <- renderPlot({
  
  #csv.file <- read.csv("E:/Recess2/Data_set_2_Chat_analysis/csv file.csv", header=FALSE)
  #str(csv.file)
  myfile() %>% select(Minutes) %>% mutate(Minutes = hms(Minutes)) %>% mutate(Minutes = hour(Minutes))%>%mutate(Minutes = as.factor(Minutes))%>%
    ggplot(aes(x= Minutes))+
    geom_bar()+
    labs(title="ggplot showing number of messages sent and recieved in a given hour",
         x="Time",
         y="Number of messages per hour")
  
})

#summaries
output$sum <- renderTable({
  
summary(myfile())
  
})

#code for customer care perfomance
output$customerCare <- renderPlot({
  
  mydatasetcorpus <- Corpus(VectorSource(myfile()$Operator))
  
  #Cleaning
  mydataset = gsub("[[:punct:]]", "", myfile()$Operator)
  mydataset = gsub("[[:punct:]]", "", mydataset)
  mydataset = gsub("[[:digit:]]", "", mydataset)
  mydataset = gsub("http\\w+", "", mydataset)
  textdata = gsub("[ \t]{2,}", "", mydataset)
  mydataset = gsub("^\\s+|\\s+$", "", mydataset)
  
  
  dtm <- TermDocumentMatrix(mydatasetcorpus)
  termFrequency <- rowSums(as.matrix(dtm))
  termFrequency <- subset(termFrequency, termFrequency <=1200)
  barplot(termFrequency, col = rainbow(20), main = "Bar plot showing the perfomance of the different customercare operators", xlab = "Operators", ylab = "Perfomance")
  
  
  
})

#Advertising preference
output$advert <- renderPlot({
  
  mydatasetcorpus <- Corpus(VectorSource(myfile()$Came.from))
  
  #Cleaning
  #mydataset = gsub("[[:punct:]]", "", myfile()$Came.from)
  #mydataset = gsub("[[:punct:]]", "", mydataset)
  #mydataset = gsub("[[:digit:]]", "", mydataset)
  #mydataset = gsub("http\\w+", "", mydataset)
  #textdata = gsub("[ \t]{2,}", "", mydataset)
  #mydataset = gsub("^\\s+|\\s+$", "", mydataset)
  
  
  dtm <- TermDocumentMatrix(mydatasetcorpus[1:100])
  findFreqTerms(dtm, lowfreq = 15)
  termFrequency <- rowSums(as.matrix(dtm))
  termFrequency <- subset(termFrequency, termFrequency <=1200)
  barplot(termFrequency,las = 2, col = rainbow(20), main = "Bar plot showing the perfomance of the different websites used.", xlab = "Websites", ylab = "Usage")
  
  
  
})



})