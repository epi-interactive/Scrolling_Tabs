shinyServer(function(input, output){
  
  
  shinyjs::runjs("Shiny.setInputValue('activeSection', 'new_zealand_section');")
  
  
  # Handle click events on the side bar
  # ------------------------------------------------------------------------------------------------
  observeEvent(input$tabs, {
    
    clicked <- NULL
    
    # Set a value based on what was clicked
    if(input$tabs == "Wellington" || input$tabs == "Christchurch"){
      clicked  <-  "section1"
    } else if(input$tabs == "Auckland" || input$tabs == "Queenstown"){
      clicked <- "section2"
    } else if(input$tabs == "Tauranga" || input$tabs == "Dunedin"){
      clicked <- "section3"
    } else if(input$tabs == "Hamilton" || input$tabs == "Invercargill"){
      clicked <- "section4"
    } else if(input$tabs == "Napier" || input$tabs == "Gore"){
      clicked <- "section5"
    } else if(input$tabs == "Palmerston North" || input$tabs == "Ashburton"){
      clicked <- "section6"
    } else if(input$tabs == "Gisborne" || input$tabs == "Rangiora" ){
      clicked <- "section7"
    } else if(input$tabs == "Rotorua" || input$tabs == "Picton"){
      clicked <- "section8"
    } 
    
    if(!is.null(clicked)) {
      shinyjs::runjs(paste0("scrollToElement(", clicked, ")"))
    }
  })
  
  
  # The page. Sections are generated individually and rendered together with this output
  # ------------------------------------------------------------------------------------------------
  output$page <- renderUI({
    req(input$activeSection)
    
    if(input$activeSection == "new_zealand_section" || input$activeSection == "new zealand map"){
      uiOutput("new_zealand_section")
    }else if(input$activeSection == "South_island_towns") {
       uiOutput("South_Island_section")
    }else if(input$activeSection == "North_island_towns"){
       uiOutput("North_Island_section")
    }
  })
  
  output$new_zealand_section <- renderUI({
    div(class="overview-section",style="padding-bottom: 1000px",
        div(class="overview-section-title", "New Zealand"),
        m <- leaflet(height=400, width=600) %>%
          addTiles() %>%  # Add default OpenStreetMap map tiles
          setView(lng=174.8860, lat=-40.9006,zoom = 5)
    )
  })
  
  output$South_Island_section <- renderUI({
    # Single page layout rather than switch
    tagList(
      div(class="overview-title-section"
      ),
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
      div(class="overview-title-section"
      ),
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
    div(class="overview-section",style="padding-bottom: 40px",
        div(class="overview-section-title",  id="section1", "Wellington"),
        m <- leaflet(height=400, width=600) %>%
          addTiles() %>%  # Add default OpenStreetMap map tiles
          setView(lng=174.7731, lat=-41.2769,zoom = 12)
    )
  })

  # Content for section - Auckland
  # ------------------------------------------------------------------------------------------------
  output$section2_tab1 <- renderUI({
    div(class="overview-section",style="padding-bottom: 40px",
        div(class="overview-section-title", id="section2", "Auckland"),
        m <- leaflet(height=400, width=600) %>%
          addTiles() %>%  # Add default OpenStreetMap map tiles
          setView(lng=174.7625, lat=-36.8483,zoom = 12)
    )
  })
  
  # Content for section - Tauranga
  # ------------------------------------------------------------------------------------------------
  output$section3_tab1 <- renderUI({
    div(class="overview-section",style="padding-bottom: 40px",
        div(class="overview-section-title",id="section3", "Tauranga"),
        m <- leaflet(height=400, width=600) %>%
          addTiles() %>%  # Add default OpenStreetMap map tiles
          setView(lng=176.2226, lat=-37.6763,zoom = 12)
    )
  })
  
  # Content for section - Hamilton
  # ------------------------------------------------------------------------------------------------
  output$section4_tab1 <- renderUI({
    div(class="overview-section",style="padding-bottom: 40px;",
        div(class="overview-section-title",id = "section4", "Hamilton"),
        m <- leaflet(height=400, width=600) %>%
          addTiles() %>%  # Add default OpenStreetMap map tiles
          setView(lng=175.2597, lat=-37.7891,zoom = 12)
    )
  })
  
  # Content for section - Napier
  # ------------------------------------------------------------------------------------------------
  output$section5_tab1 <- renderUI({
    div(class="overview-section",style="padding-bottom: 40px;",
        div(class="overview-section-title",id="section5", "Napier"),
        m <- leaflet(height=400, width=600) %>%
          addTiles() %>%  # Add default OpenStreetMap map tiles
          setView(lng=176.9136, lat=-39.4919, zoom = 12)
    )
  })
  
  # Content for section - Palmerston North
  # ------------------------------------------------------------------------------------------------
  output$section6_tab1 <- renderUI({
    div(class="overview-section",style="padding-bottom: 40px;",
        div(class="overview-section-title",id="section6", "Palmerston North"),
        m <- leaflet(height=400, width=600) %>%
          addTiles() %>%  # Add default OpenStreetMap map tiles
          setView(lng=175.6067, lat=-40.3584, zoom = 12)
    )
  })
  
  # Content for section - Gisborne
  # ------------------------------------------------------------------------------------------------
  output$section7_tab1 <- renderUI({
    div(class="overview-section",style="padding-bottom: 40px;",
        div(class="overview-section-title", id="section7", "Gisborne"),
        m <- leaflet(height=400, width=600) %>%
          addTiles() %>%  # Add default OpenStreetMap map tiles
          setView(lng=177.9980, lat=-38.6517, zoom = 12)
       )
  })
  
  # Content for section - Rotorua
  # ------------------------------------------------------------------------------------------------
  output$section8_tab1 <- renderUI({
    div(class="overview-section", style="padding-bottom: 40px;",
        div(class="overview-section-title", id="section8", "Rotorua"),
        m <- leaflet(height=400, width=600) %>%
          addTiles() %>%  # Add default OpenStreetMap map tiles
          setView(lng=176.2378, lat=-38.1446, zoom = 12)
        )
  })
  

# South Island ----------------------------------------------------

# Content for section - Christchurch
# ------------------------------------------------------------------------------------------------
output$section1_tab2 <- renderUI({
  div(class="overview-section",style="padding-bottom: 40px;",
      div(class="overview-section-title",id="section1", "Christchurch"),
      m <- leaflet(height=400, width=600) %>%
        addTiles() %>%  # Add default OpenStreetMap map tiles
        setView(lng=172.6397, lat=-43.5320, zoom = 12)
      
  )
})
  
# Content for section - Queenstown
# ------------------------------------------------------------------------------------------------  
output$section2_tab2 <- renderUI({
  div(class="overview-section",style="padding-bottom: 40px;",
      div(class="overview-section-title", id="section2", "Queenstown"),
      m <- leaflet(height=400, width=600) %>%
        addTiles() %>%  # Add default OpenStreetMap map tiles
        setView(lng=168.6616, lat=-45.0302, zoom = 12)
  )
})  

# Content for section - Dunedin
# ------------------------------------------------------------------------------------------------
output$section3_tab2 <- renderUI({
  div(class="overview-section",style="padding-bottom: 40px;",
      div(class="overview-section-title",id="section3", "Dunedin"),
      m <- leaflet(height=400, width=600) %>%
        addTiles() %>%  # Add default OpenStreetMap map tiles
        setView(lng=170.4911, lat=-45.8668, zoom = 12)
  )
})

# Content for section - Invercargill
# ------------------------------------------------------------------------------------------------
output$section4_tab2 <- renderUI({
  div(class="overview-section",style="padding-bottom: 40px;",
      div(class="overview-section-title", id = "section4", "Invercargill"),
      m <- leaflet(height=400, width=600) %>%
        addTiles() %>%  # Add default OpenStreetMap map tiles
        setView(lng=168.3615, lat=-46.4179, zoom = 12)
  )
})

# Content for section - Gore
# ------------------------------------------------------------------------------------------------
output$section5_tab2 <- renderUI({
  div(class="overview-section",style="padding-bottom: 40px;",
      div(class="overview-section-title",id = "section5", "Gore"),
      m <- leaflet(height=400, width=600) %>%
        addTiles() %>%  # Add default OpenStreetMap map tiles
        setView(lng=168.9459, lat=-46.0989, zoom = 12)
  )
})

# Content for section - Ashburton
# ------------------------------------------------------------------------------------------------
output$section6_tab2 <- renderUI({
  div(class="overview-section",style="padding-bottom: 40px;",
      div(class="overview-section-title", id = "section6", "Ashburton"),
      m <- leaflet(height=400, width=600) %>%
        addTiles() %>%  # Add default OpenStreetMap map tiles
        setView(lng=171.7209, lat=-43.9196, zoom = 12)
  )
})

# Content for section - Rangiora
# ------------------------------------------------------------------------------------------------  
output$section7_tab2 <- renderUI({
  div(class="overview-section",style="padding-bottom: 40px;",
      div(class="overview-section-title", id = "section7", "Rangiora"),
      m <- leaflet(height=400, width=600) %>%
        addTiles() %>%  # Add default OpenStreetMap map tiles
        setView(lng=172.5905, lat=-43.3040, zoom = 12)
  )
})

# Content for section - Picton
# ------------------------------------------------------------------------------------------------  
output$section8_tab2 <- renderUI({
  div(class="overview-section",style="padding-bottom: 40px;",
      div(class="overview-section-title", id = "section8", "Picton"),
      m <- leaflet(height=400, width=600) %>%
        addTiles() %>%  # Add default OpenStreetMap map tiles
        setView(lng=174.0057, lat=-41.2930, zoom = 12)
  )
})
})