people <- c("adelmo","carlitos","charles","eurico","jeremy","pedro")
mmodel <- c("Quadratic Discriminant Analysis"="qda","Classification Trees"="rpart")
mmethod <- c("k-fold"="cv","bootstrap"="boot","leave group out"="LGOCV")

# USING 5 PARTICIPANTS TO PREDICT SAMPLES FROM ONE EXCLUDED PERSON

library(shiny)
shinyUI(fluidPage(
    titlePanel("We will be using the training dataset from our last machine learning
               assignment. To explain the dataset, 6 participants were asked to
               perform 5 ways of doing a dumbbell bicep curl, with 10 repetitions
               per way. Out of the 5 ways, method A is correct while method B to E
               represent common mistakes. We will use 5 participants to predict
               samples from one excluded participant. We will then compare both
               expected and actual accuracies."),
    sidebarLayout(
        sidebarPanel(
            selectInput("predictee", "Step 1. select person to exclude", people),
            selectInput("model", "Step 2. select model", mmodel),
            selectInput("method", "Step 3. select cross-validation method", mmethod),
            numericInput("k", "Step 4. select number of folds or bootstraps or repeated splits",
                         value=6, min=3, max=9, step=1),
            "Step 5. highlight or 'brush' some sample points on the plot
            to be submitted as test set for prediction - and KINDLY wait a few
            seconds for both expected and actual accuracies to
            be updated"
            # submitButton("Submit")
        ),
        mainPanel(style="font-size:30px;font-weight:bold;color:red",
            plotOutput("plot1", brush=brushOpts(id="brush1")),
            textOutput("text1")
        )
    )
))