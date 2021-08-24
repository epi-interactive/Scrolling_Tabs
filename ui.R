shinyUI(
   tagList(
      useShinyjs(),
      tags$head(    
         tags$script(src="js/util.js"),
         tags$script(src="js/verticalTabs.js"),
         tags$link(rel = "stylesheet", type = "text/css", href = "css/styles.css"),
      ),
      div(class="flex-sidebar",
          div(
             class="overview-tabs vertical-tabs",
             verticalTabsInput("tabs",
                               list(
                                  "New Zealand Map",
                                  "North Island towns" = list(
                                     "Wellington",
                                     "Auckland",
                                     "Tauranga",
                                     "Hamilton",
                                     "Napier",
                                     "Palmerston North",
                                     "Gisborne",
                                     "Rotorua"
                                  ),
                                  "South Island towns" = list(
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
                               
             )
          )
      ),
      div(class="container-fluid flex-main",
          fluidRow(class="content-pad",
                   column(12,
                          uiOutput("page")
                   )
          )
      )
   )
)