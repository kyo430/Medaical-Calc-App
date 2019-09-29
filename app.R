#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(shinyjs)

# Define UI for application that draws a histogram
ui <- dashboardPage(
    dashboardHeader(title = "Medical Culculation"
                    ,dropdownMenu(type = "message",
                                  messageItem(
                                      from = "Version",
                                      message = "Version 1.0.1",
                                      icon = icon("life-ring"),
                                      time = "2019-9-21"
                                  )
                    )),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Gamma culculation", icon = icon("line-chart"), tabName = "gamma")
        )
    ),
    dashboardBody(
        shinyjs::useShinyjs(),
        tabItem("gamma",
                h1("Gamma culculation"),
                box(
                    title = "Input Data",
                    status = "primary",
                    solidHeader = TRUE,
                    width = 12,
                    numericInput("weight", "Body weight(kg)", NULL, min = 0, max = 200, step = NA, width = NULL),
                    numericInput("concentration", "Drug concentration(mg/ml)", NULL, min = 0, max = 20, step = NA, width = NULL)
                ),
                fluidRow(
                    box(
                        title = "Output",
                        status = "success", width=12,
                        actionButton("Calc", "Calc start", width = "30%", icon = icon("repeat"), class = "btn btn-warning"),
                        br(),
                        br(),
                        valueBoxOutput("Introduction")
                    )
                )
                )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    #計算起動ボタンの有効か
    observe({
        if(!is.numeric(input$weight) || !is.numeric(input$concentration)){
            shinyjs::disable("Calc")
        }
        else{
            shinyjs::enable("Calc")
        }
    })
    #one_gammmaを計算
    Introduction_calc = reactive({
        one_gamma <- input$weight * 0.06
        
        Intro_value <- one_gamma / input$concentration
        Intro_value <- round(Intro_value, digits = 1)
        
        Intro_value
    })
    #出力表示
    observeEvent(input$Calc, {
        #投入量の計算
        Intro_value <- Introduction_calc()
        #画面に出力
        output$Introduction <- renderValueBox({
            valueBox(Intro_value, "Introduction(ml/h)", icon = icon("notes-medical"), color="red")
        })
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
