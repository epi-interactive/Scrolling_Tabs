library(shiny)
library(shiny.router)
library(shinyjs)
library(dplyr)
library(readxl)
library(htmltools)
library(leaflet)
source("source/util/pageUtil.R") 
source("source/util/verticalTabsInput.R")

shinyUI(
   tagList(
   useShinyjs(),
   bootstrapPage(NULL, theme = "css/bootstrap.min.css"),
   tags$head(    
   tags$script(src="js/util.js"),
   tags$script(src="js/smoothScrollJquery.js"),
   tags$script(src="js/verticalTabs.js"),
   tags$link(rel = "stylesheet", type = "text/css", href = "css/font-awesome.min.css"),
   tags$link(rel = "stylesheet", type = "text/css", href = "css/styles.css"),
   tags$link(rel = "stylesheet", type = "text/css", href = "css/cc_custom.css"),
   tags$link(rel = "stylesheet", type = "text/css", href = "css/indicator-custom.css"),
   tags$link(rel = "stylesheet", type = "text/css", href = "css/nprogress.css")
   ),
   createFlexSidebarPage("overview",
                           div(
                             class="overview-tabs vertical-tabs",
                             verticalTabsInput("tabs",
                                            list(
                                                "New Zealand Map",
                                                "North island towns" = list(
                                                    "Wellington",
                                                    "Auckland",
                                                    "Tauranga",
                                                    "Hamilton",
                                                    "Napier",
                                                    "Palmerston North",
                                                    "Gisborne",
                                                    "Rotorua"
                                                ),
                                                "South island towns" = list(
                                                    "Christchurch",
                                                    "Queenstown",
                                                    "Dunedin",
                                                    "Invercargill",
                                                    "Gore",
                                                    "Ashburton",
                                                    "Rangiora",
                                                    "picton"
                                                )
                                            )
                                            
                          )
                        ),
                        fluidRow(class="content-pad",
                                 column(12,
                                        uiOutput("page")
                                 )
                        ),
                        "Overview",
                        T
  ),
   )
)