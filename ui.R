library(shiny)
library(shiny.router)
library(shinyjs)
library(dplyr)
library(readxl)
library(htmltools)
library(leaflet)
source("source/util/verticalTabsInput.R")
source("source/util/pageUtil.R")

shinyUI(
   tagList(
   useShinyjs(),
   bootstrapPage(NULL),
   tags$head(    
   tags$script(src="js/util.js"),
   tags$script(src="js/verticalTabs.js"),
   tags$link(rel = "stylesheet", type = "text/css", href = "css/styles.css"),
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
                                                    "Picton"
                                                )
                                            )
                                            
                          ),div(class="imgDiv", img(class="tab-logo",src= "img/Epi_Logo_HZ_Solid_REV.png")),
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