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


shinyServer(function(input, output, session){
  
output$about <- renderText({})
  
#wordcloud
 myfile <- reactive({
   
   if(is.null(input$file)){
     return()
   }
    mystore <- read.csv(file = input$file$datapath,  T, ",")
    mystore
    
    
 })
 output$wordcloud <- renderPlot({
mydataset = gsub("[[:digit:]]", "", myfile()$Chat.content)
   
 
 mydatasetcorpus <- Corpus(VectorSource(mydataset))
 
 
 #corpus cleaning
 cleancorpus <- tm_map(mydatasetcorpus, stripWhitespace)
 
 
 cleancorpus <- tm_map(mydatasetcorpus, removePunctuation)
 
 
 cleancorpus <- tm_map(mydatasetcorpus, PlainTextDocument)
 
 cleancorpus <- tm_map(mydatasetcorpus, removeNumbers)
 
 cleancorpus <- tm_map(mydatasetcorpus, removeWords, stopwords("english"))
 
 cleancorpus <- tm_map(mydatasetcorpus, content_transformer(tolower))
 
 
 
 wordcloud(cleancorpus, min.freq = input$wd, max.words = input$wcloud,   colors = brewer.pal(8,"Set2"), random.order = F )
 


  
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
   View(mydataset)
   
   
   mydataset <- gettext(file$Chat.content)
   View(mydataset)
   
   
   # Characters per email
   characters_per_email <- nchar(mydataset)
   summary(characters_per_email)
   
   sapply(file$Chat.content, function(x) max(nchar(x)))
   
   
   # Split words
   words_list = strsplit(file$Chat.content, " ")
   
   # Words per email 
   words_per_email = sapply(words_list, length)
   View(words_per_email)
   barplot(table(words_per_email), border=NA, main="Distribution of words per email", cex.main=1, axes = T)
   
   # How long is the typical email?
   max(words_per_email)
   
   
   #	How does email length differ by rating?
   data <- cbind(words_per_email, file)
   
   
   # Length of words per email
   word_length = sapply(words_list, function(x) mean(nchar(x)))
   barplot(table(round(word_length)), border=NA,xlab = "Word length in number of characters", main="Distribution of words length per email", cex.main=1)
   
   
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
   
   cleancorpus <- tm_map(mydatasetcorpus, removeWords, c("this", "part","the","they","and","was","for","there"))
   
   #wordcloud(cleancorpus, min.freq = 5, colors = brewer.pal(9,"Set2"), random.order = F)
   
   
   dtm <- TermDocumentMatrix(mydatasetcorpus[1:100], control = list(removeNumbers = T, removePunctuation = T, stripWhitespace = T, tolower = T, stopwords = T, stemming = T))
   findFreqTerms(dtm, lowfreq = 15)
   termFrequency <- rowSums(as.matrix(dtm))
   #termFrequency[1:50]
   termFrequency <- subset(termFrequency, termFrequency >=15)
   barplot(termFrequency, las = 2, col = rainbow(20),main = "Bar plot showing mostly used words", xlab = "frequency", ylab = "words")
   
   
 })
 
 #BarPlot2
 output$barplot <- renderPlot({
   
   mydatasetcorpus <- Corpus(VectorSource(mydataset$Country))
   dtm <- TermDocumentMatrix(mydatasetcorpus, control = list(removeNumbers = T, removePunctuation = T, stripWhitespace = T))
   termFrequency <- rowSums(as.matrix(dtm))
   barplot(termFrequency, las = 2, col = rainbow(20),main = "Bar plot showing participation of the different countries", xlab = "countries", ylab = "participation")
   
   
 })
 
 #ScatterPlot
 output$scatterPlot <- renderPlot({
   
   plot(myfile()$Minutes~myfile$Chat.content, main = "Scatter plot showimg the number of emails sent at agiven time.", xlab ="Emails sent", ylab = "Time", axes = T )
   
 })
 
 #download
 x <- reactive({
   wordcloud[,as.numeric(input$radio)]
 })
 
 y <- reactive({
   wordcloud[,as.numeric(input$radio)]
 })
 
 
 output$down <- downloadHandler(
   #specify file name
   filename = function(){
     paste("wordcloud",input$radio, sep = ".")
   }, 
   
   #open device
   #write file
   #open device
   content = function(){
     if(input$radio == "png")
       png(file)
     else
     pdf(file)
     wordcloud(cleancorpus, min.freq = input$wd, max.words = input$wcloud,   colors = brewer.pal(8,"Set2"), random.order = F )
     dev.off()
     
   }
   
 )
})