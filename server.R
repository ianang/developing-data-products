# URL <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
# download.file(URL, "./training.csv")
training <- read.csv("./training.csv", na.strings=c("#DIV/0!","NA",""))
removal.terms <- c("kurtosis","skewness","max_","min_","amplitude",
                   "var_","avg_","stddev","cvtd_","new_window","num_window")
removal.list <- unique(unlist(sapply(removal.terms,grep,names(training))))
training <- training[,-removal.list]
training$X <- NULL
training <- training[with(training,order(user_name,
                                         raw_timestamp_part_1,
                                         raw_timestamp_part_2)),]

library(shiny)
library(caret)
library(e1071)
shinyServer(function(input, output) {
    model <- reactive({
        testing <- brushedPoints(training[training$user_name==input$predictee,], input$brush1,
                                 xvar="total_accel_arm", yvar="total_accel_forearm")
        if(nrow(testing) < 2) {return(NULL)}
        trainer <- training[training$user_name!=input$predictee,-(1:3)]
        trControl <- trainControl(method=input$method, number=input$k)
        modfit <- train(classe~., data=trainer, method=input$model, trControl=trControl)
        cm <- confusionMatrix(predict(modfit,testing), testing$classe)
        paste("expected accuracy =", round(as.numeric(modfit$results[1,2]),3),
              ", actual accuracy =", round(as.numeric(cm$overall[1]),3))
    })
    output$plot1 <- renderPlot({
        plot(x=training[training$user_name==input$predictee,]$total_accel_arm,
             xlab=paste(input$predictee, "total_accel_arm"),
             y=training[training$user_name==input$predictee,]$total_accel_forearm,
             ylab=paste(input$predictee, "total_accel_forearm"),
             main=paste(input$predictee, "data points"))
    })
    output$text1 <- renderText({
        model()
    })
})