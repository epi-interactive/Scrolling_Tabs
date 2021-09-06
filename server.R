##################################
# Created by EPI-interactive
# 04 Feb 2021
# https://www.epi-interactive.com
##################################

shinyServer(function(input, output){
  
  
  shinyjs::runjs("Shiny.setInputValue('activeSection', 'new_zealand_section');")
  

  # Set up map 
  # ------------------------------------------------------------------------------------------------
  getMap <- function(title, lng, lat, zoom  = 12){
    div(class="overview-section",
        div(class="overview-section-title", id=gsub(" ", "", title), title),
        leaflet(height=400, width=600) %>%
          addTiles() %>%  # Add default OpenStreetMap map tiles
          setView(lng=lng, lat=lat,zoom = zoom)
    )
  }
  
  # Handle click events on the side bar
  # ------------------------------------------------------------------------------------------------
  observeEvent(input$tabs, {
    clicked <- gsub(" |\n", "", input$tabs)
    headings <- c("NewZealandMap", "NorthIslandtowns", "SouthIslandtowns")
    
    if(!is.null(clicked) & clicked !="" & !clicked %in% headings) {
      shinyjs::runjs(paste0("scrollToElement(", clicked, ")"))
    }
  })
  
  # The page. Sections are generated individually and rendered together with this output
  # ------------------------------------------------------------------------------------------------
  output$page <- renderUI({
    req(input$activeSection)
    
    if(input$activeSection == "new_zealand_section"){
      uiOutput("new_zealand_section")
    }else if(input$activeSection == "South_island_towns") {
       uiOutput("South_Island_section")
    }else if(input$activeSection == "North_island_towns"){
       uiOutput("North_Island_section")
    }
  })
  
  output$new_zealand_section <- renderUI({
    getMap("New Zealand", lng=174.8860, lat=-40.9006,zoom = 5)
  })
  
  output$South_Island_section <- renderUI({
    # Single page layout rather than switch
    tagList(
      uiOutput("section1_tab2"),
      uiOutput("section2_tab2"),
      uiOutput("section3_tab2"),
      uiOutput("section4_tab2"),
      uiOutput("section5_tab2"),
      uiOutput("section6_tab2"),
      uiOutput("section7_tab2"),
      uiOutput("section8_tab2")
    )
  })
  
  output$North_Island_section <- renderUI({
    # Single page layout rather than switch
    tagList(
      uiOutput("section1_tab1"),
      uiOutput("section2_tab1"),
      uiOutput("section3_tab1"),
      uiOutput("section4_tab1"),
      uiOutput("section5_tab1"),
      uiOutput("section6_tab1"),
      uiOutput("section7_tab1"),
      uiOutput("section8_tab1")
    )
  })

  # North Island ----------------------------------------------------
  
  # Content for section - Wellington
  # ------------------------------------------------------------------------------------------------
  output$section1_tab1 <- renderUI({
    getMap("Wellington", lng=174.7731, lat=-41.2769)
  })

  # Content for section - Auckland
  # ------------------------------------------------------------------------------------------------
  output$section2_tab1 <- renderUI({
    getMap("Auckland", lng=174.7625, lat=-36.8483)
  })
  
  # Content for section - Tauranga
  # ------------------------------------------------------------------------------------------------
  output$section3_tab1 <- renderUI({
    getMap("Tauranga", lng=176.2226, lat=-37.6763)
  })
  
  # Content for section - Hamilton
  # ------------------------------------------------------------------------------------------------
  output$section4_tab1 <- renderUI({
    getMap("Hamilton", lng=175.2597, lat=-37.7891)
  })
  
  # Content for section - Napier
  # ------------------------------------------------------------------------------------------------
  output$section5_tab1 <- renderUI({
    getMap("Napier",lng=176.9136, lat=-39.4919)
  })
  
  # Content for section - Palmerston North
  # ------------------------------------------------------------------------------------------------
  output$section6_tab1 <- renderUI({
    getMap("Palmerston North", lng=175.6067, lat=-40.3584)
  })
  
  # Content for section - Gisborne
  # ------------------------------------------------------------------------------------------------
  output$section7_tab1 <- renderUI({
    getMap("Gisborne",lng=177.9980, lat=-38.6517)
  })
  
  # Content for section - Rotorua
  # ------------------------------------------------------------------------------------------------
  output$section8_tab1 <- renderUI({
    getMap("Rotorua", lng=176.2378, lat=-38.1446)
  })
  

  # South Island ----------------------------------------------------
  
  # Content for section - Christchurch
  # ------------------------------------------------------------------------------------------------
  output$section1_tab2 <- renderUI({
    getMap("Christchurch",lng=172.6397, lat=-43.5320)
  })
    
  # Content for section - Queenstown
  # ------------------------------------------------------------------------------------------------  
  output$section2_tab2 <- renderUI({
    getMap("Queenstown",lng=168.6616, lat=-45.0302)
  })  
  
  # Content for section - Dunedin
  # ------------------------------------------------------------------------------------------------
  output$section3_tab2 <- renderUI({
    getMap("Dunedin",lng=170.4911, lat=-45.8668)
  })
  
  # Content for section - Invercargill
  # ------------------------------------------------------------------------------------------------
  output$section4_tab2 <- renderUI({
    getMap("Invercargill", lng=168.3615, lat=-46.4179)
  })
  
  # Content for section - Gore
  # ------------------------------------------------------------------------------------------------
  output$section5_tab2 <- renderUI({
    getMap("Gore",lng=168.9459, lat=-46.0989)
  })
  
  # Content for section - Ashburton
  # ------------------------------------------------------------------------------------------------
  output$section6_tab2 <- renderUI({
    getMap("Ashburton",lng=171.7209, lat=-43.9196)
  })
  
  # Content for section - Rangiora
  # ------------------------------------------------------------------------------------------------  
  output$section7_tab2 <- renderUI({
    getMap("Rangiora",lng=172.5905, lat=-43.3040)
  })
  
  # Content for section - Picton
  # ------------------------------------------------------------------------------------------------  
  output$section8_tab2 <- renderUI({
    getMap("Picton",lng=174.0057, lat=-41.2930)
  })
})
