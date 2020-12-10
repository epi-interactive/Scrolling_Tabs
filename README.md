# Dynamic Scroll to element
This build vertical tab bar which can be used to smoothly navigate to the chosen elements by clicking on the approriate tab. When dealing with long webpages it is more convenient to choose which title to explore from a tab selection rather than scrolling to the title. This can be done using scroll to element function implemented in JavaScript.

# How it works

![Scroll to element navigation found in Cancer Care explorer](https://github.com/epi-interactive/Cancer_care-navigation/blob/master/navigation%20cancer%20care.PNG)
1. Create a vertical tabs input inside a sidebar page. The vertical tabs contain a list of names of all tabs.
 ``` r
    createFlexSidebarPage(ns("overview"),
                        div(
                          class="overview-tabs vertical-tabs",
                          verticalTabsInput(ns("tabs"),
                                            list(
                                                "Summary",
                                                "Bowel cancer" = list(
                                                    "Background",
                                                    "Indicators",
                                                    "Diagnosis",
                                                    "Characteristics",
                                                    "Treatment",
                                                    "More information"
                                                ),
                                                "Lung cancer" = list(
                                                    "Background",
                                                    "Indicators",
                                                    "Diagnosis",
                                                    "Characteristics",
                                                    "Treatment",
                                                    "Overall survival",
                                                    "End-of-life",
                                                    "Mortality"
                                                )
                                            )
                                            
                          )
                        ),
                        fluidRow(class="content-pad",
                                 column(12,
                                        uiOutput(ns("page"))
                                 )
                        ),
                        "Overview",
                        T
  )
 ```
2. The observe Event reactive function is used to handle the events on the side bar. If the tab is clicked a value based on the name of the tab that was clicked is stored in a variable.
 ``` r
    observeEvent(input$tabs, {
    
    clicked <- NULL
    
    # Set a value based on what was clicked
    if(input$tabs == "Background"){
      clicked  <-  "Background"
    } else if(input$tabs == "Indicators"){
      clicked <- "Indicators"
    } else if(input$tabs == "Diagnosis"){
      clicked <- "Diagnosis"
    } else if(input$tabs == "Characteristics"){
      clicked <- "Characteristics"
    } else if(input$tabs == "Treatment"){
      clicked <- "Treatment"
    } else if(input$tabs == "More information"){
      clicked <- "Information"
    } else if(input$tabs == "Overall survival"){
      clicked <- "Survival"
    } else if(input$tabs == "End-of-life"){
      clicked <- "EndOfLife"
    } else if(input$tabs == "Mortality"){
      clicked <- "Mortality"
    }
    
    if(!is.null(clicked)) {
      shinyjs::runjs(paste0("scrollToElement(", clicked, ")"))
    }
  })
 ```
3. The scroll to Element JavaScript function is also called every time a tab is clicked, and the name of the tab is passed in the parameter.
 ``` r
 const scrollToElement = function(element) {
  console.log(element);
  if(navigator.sayswho.indexOf("IE") > -1) {
    $("html, body").animate({
        scrollTop: element.offsetTop
    }, 1500);

  } else {
    window.scroll({ 
      top: element.offsetTop,
      left: element.offsetLeft,
      behavior: 'smooth'
    });
  }
};
```
4. The scroll to Element function verifies if the browser used is Internet Explorer and if it is the case the animate method is used to scroll to the top of the element. Otherwise, the window. Scroll method is used.
``` r
# Content for section - Background
  # ------------------------------------------------------------------------------------------------
  output$background_bc <- renderUI({
    div(class="overview-section",
        div(class="overview-section-title",  id="Background", "Background"),
        div(class="overview-section-content",
            p("Bowel cancer is the third most common cancer diagnosed in New Zealand."),
            p("The Bowel Cancer Quality Improvement Report describes and compares the diagnosis, care and outcomes of people diagnosed with bowel cancer."),
            p("This report summarises some of the key findings from the 2019 report."),
            p("It is primarily a document for healthcare professionals and service providers but people with bowel cancer and the general public may also find the data interesting. The full report, which contains more information about the methods of data collection and analysis, as well as DHB results, can be accessed at: "
             ),
            p(tags$a(style="margin-right: -5px", target="_blank", href="https://www.health.govt.nz", "https://www.health.govt.nz") )
        )
    )
  })
```
5. Each section is rendered using render UI reactive function 
