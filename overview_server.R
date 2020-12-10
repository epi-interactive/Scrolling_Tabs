pageOverview <- function(input, output, session, name, moduleControl) {
  ns <- session$ns
  
  
  observeEvent(input$routeOverview, {
    change_page("overview")
  })
  
  # Adjust page title (in the tab) when the page changes
  # ------------------------------------------------------------------------------------------------
  observeEvent(moduleControl$currentPage(), {
    if(moduleControl$currentPage() == "overview") {
      shinyjs::runjs("setPageTitle('Overview')")
      shinyjs::runjs("Shiny.setInputValue('overview-activeSection', 'summary');")
    }
  })

  
  # Handle click events on the side bar
  # ------------------------------------------------------------------------------------------------
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
  

  # The page. Sections are generated individually and rendered together with this output
  # ------------------------------------------------------------------------------------------------
  output$page <- renderUI({
    
    if(input$activeSection == "summary") {
      out <- uiOutput(ns("summary_section"))
    }
    else if(input$activeSection == "bowel_cancer") {
      out <- uiOutput(ns("bowel_cancer_section"))
    }
    else if(input$activeSection == "lung_cancer") {
      out <- uiOutput(ns("lung_cancer_section"))
    }
    
    return(out)
  })

  
  
  output$summary_section <- renderUI({
    tagList(
      div(class="overview-title-section",
          div(class="static-title overview-title",
              "Summary"
          ),
          div(class = "overview-title-subtitle-section",
              div(class="overview-subtitle",
                  "National results overview"
              ),
              p("This section displays a high-level descriptive and pictorial overview of the latest national results from the Cancer Quality Performance Indicator Programme of Te Aho o Te Kahu.")
          )
      ),
      div(class = "overview-section-title", "Latest results"),
      p("The first bowel cancer quality indicator results were published in March 2019."),
      p("Lung cancer results will be published following DHB review of the results.")
    )
  })
  
  output$bowel_cancer_section <- renderUI({
    # Single page layout rather than switch
    tagList(
      div(class="overview-title-section",
          div(class="static-title overview-title",
              "Bowel Cancer in New Zealand"
          ),
          div(class="overview-title-subtitle-section",
              div(class="overview-subtitle", "A summary report about the management and outcomes of people with bowel cancer"),
              p("Based on findings from the ", tags$a(target="_blank", style="margin-right:-3px", "Bowel Cancer Quality Improvement Report 2019", href="https://www.health.govt.nz/publication/bowel-cancer-quality-improvement-report-2019"), ".")
          )
      ),
      uiOutput(ns("background_bc")),
      uiOutput(ns("indicators_bc")),
      uiOutput(ns("diagnosis_bc")),
      uiOutput(ns("characteristics_bc")),
      uiOutput(ns("treatment_bc")),
      uiOutput(ns("surgeryBowel_bc")),
      uiOutput(ns("surgeryRectal_bc")),
      uiOutput(ns("recommendations_bc"))
    )
  })
  
  output$lung_cancer_section <- renderUI({
    # Single page layout rather than switch
    tagList(
      div(class="overview-title-section",
          div(class="static-title overview-title",
              "Lung Cancer in New Zealand"
          ),
          div(class="overview-title-subtitle-section",
              div(class="overview-subtitle", "A summary report about the management and outcomes of people with lung cancer"),
              p("Based on findings from the ", tags$a(target="_blank", style="margin-right:-3px", "Lung Cancer Quality Improvement Report 2019", href="https://www.health.govt.nz/publication/bowel-cancer-quality-improvement-report-2019"), ".")
          )
      ),
      uiOutput(ns("background_lc")),
      uiOutput(ns("indicators_lc")),
      uiOutput(ns("diagnosis_lc")),
      uiOutput(ns("characteristics_lc")),
      uiOutput(ns("treatment_lc")),
      uiOutput(ns("survival_lc")),
      uiOutput(ns("endoflife_lc")),
      uiOutput(ns("mortality_lc"))
    )
  })

  
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

  # Content for section - Indicators
  # ------------------------------------------------------------------------------------------------
  output$indicators_bc <- renderUI({
    div(class="overview-section wide",
        div(class="overview-section-title no-line", id="Indicators", "Bowel cancer indicators"),
        div(class="overview-section-content",
            indicatorTable(G_allCancerGroupsData[["bowel_cancer"]])
        )
    )
  })
  
  # Content for section - Diagnosis
  # ------------------------------------------------------------------------------------------------
  output$diagnosis_bc <- renderUI({
    div(class="overview-section",
        div(class="overview-section-title", id="Diagnosis", "How are people diagnosed?"),
        div(class="overview-section-content",
            div(class="diagnosis-chart", 
                tags$img(width = "600px", src="img/overview/overview-diagnosis.png")
            ),
            p("People diagnosed through a screening programme are more likely to have an early cancer and be treated with a plan to cure them.")
        )
    )
  })
  
  # Content for section - Characteristics (which is actually part of diagnosis)
  # ------------------------------------------------------------------------------------------------
  output$characteristics_bc <- renderUI({
    div(class="overview-section",
        div(class="overview-section-title", id = "Characteristics", "Characteristics of people with bowel cancer"),
        div(class="overview-section-content",
            div(class="characteristics-chart", 
                tags$img(width = "600px", src="img/overview/overview_intestine_chart.png")
            ),
            p("Bowel cancer is cancer in any part of the large intestine (colon or rectum)."),
            p("It is sometimes known as colorectal cancer and might also be called colon cancer or rectal cancer, depending on where it starts."),
            p("Over 2800 people are diagnosed with bowel cancer every year in New Zealand."),
            p("The average age that a person is diagnosed with bowel cancer is 71 years old."),
            p("M\u0101ori, Pacific and Asian people are diagnosed at a younger average age of 64 years old."),
              p("In 7 out of every 10 people diagnosed the cancer is in the colon and in 3 out of every 10 people diagnosed the cancer is in the rectum.")
        )
    )
  })
  
  # Content for section - Treatment
  # ------------------------------------------------------------------------------------------------
  output$treatment_bc <- renderUI({
    div(class="overview-section",
        div(class="overview-section-title",  id="Treatment", "Treatment for people with bowel cancer"),
        div(class="overview-section-content",
            div(class="treatment-graphic", 
                tags$img(width = "600px", src="img/overview/overview-operation.png")
            ),
            p("Maximising the lymph node yield (i.e. the number of lymph nodes resected and examined) enables reliable staging of the tumour which influences the decisions made for the patient's treatment. Current guidelines recommend that a minimum of 12 nodes are harvested and examined."),
            p("82 percent of people having colon surgery had 12 or more lymph nodes examined.")
        )
    )
  })
  
  # Content for section - Surgery for bowel cancer (which is actually part of Treatment)
  # ------------------------------------------------------------------------------------------------
  output$surgeryBowel_bc <- renderUI({
    div(class="overview-section",
        div(class="overview-section-title", "Surgery for bowel cancer"),
        div(class="overview-section-content",
            p("The surgical removal of bowel cancer can have excellent outcomes for people but like all surgery can sometimes lead to serious complications. We assess this by measuring the number of people alive at 90 days after their operation."),
            p("Some people with bowel cancer may develop a blockage of the bowel. If this occurs it may be necessary for people to have an emergency operation to remove the cancer. This type of operation has more risks than planned surgery."),
            div(class="surgery-bowel-graphics",
                tags$img(width = "600px", src="img/overview/overview_97percent.png"),
                tags$img(width = "600px", style="margin-left: 6px;", src="img/overview/overview_7days.png")
            )
        )
    )
  })
  
  # Content for section - Surgery for rectal cancer (which is actually part of Treatment)
  # ------------------------------------------------------------------------------------------------
  output$surgeryRectal_bc <- renderUI({
    div(class="overview-section",
        div(class="overview-section-title", "Surgery for rectal cancer"),
        div(class="overview-section-content",
            div(class="overview-content-group", 
                p("People with rectal cancer often have different treatment than people with cancer of the colon."),
                tags$img(width = "600px", class="overview-image surgery-60", src="img/overview/overview_surgery_60percent.png")
            ),
            div(class="overview-content-group", 
                p("Radiotherapy, alone or in combination with chemotherapy, is often used before surgery. "),
                tags$img(width = "600px", class="overview-image surgery-55", src="img/overview/overview_surgery_55percent.png")
            ),
            div(class="overview-content-group", 
                p("The radiotherapy may be delivered as long-course (25 or more sessions) or short-course (5 sessions) depending on how far the tumour has spread and how likely it will return. "),
                p("38 percent have long-course radiotherapy (25 or more sessions) and 15 percent have short-course radiotherapy."),
                tags$img(width = "600px", class="overview-image surgery-stoma",src="img/overview/overview_surgery_stoma.png")
            )
        )
    )
  })
  
  # Content for section - More Information
  # ------------------------------------------------------------------------------------------------
  output$recommendations_bc <- renderUI({
    div(class="overview-section",
        div(class="overview-section-title",  id="Information", "More information"),
        div(class="overview-section-content",
            p("An awareness of the symptoms of bowel cancer is important for early diagnosis and treatment. Please contact Healthline free on 0800 611 116 or visit your GP if you have any concerns about this."),
            p("Eligible men and women aged 60 to 74 are invited to take part in bowel screening every two years. More information about the publicly funded National Bowel Screening Programme can be found at ", 
                tags$a(target="_blank", href="https://www.timetoscreen.nz/bowel-screening", "https://www.timetoscreen.nz/bowel-screening"), "."
            ),
            p("Further information and support for people and carers is available from GPs and online from ", 
              tags$a(target="_blank", style="margin-right:-5px", href="https://www.health.govt.nz/your-health/conditions-and-treatments/diseases-and-illnesses/bowel-cancer", "https://www.health.govt.nz/your-health/conditions-and-treatments/diseases-and-illnesses/bowel-cancer"), "."
            ),
            p("The full Bowel Cancer Quality Improvement report can be accessed at ", 
              tags$a(target="_blank", style="margin-right:-5px", href="https://www.health.govt.nz", "https://www.health.govt.nz"), "."
            )
        )
    )
  })
  

# Lung cancer overview ----------------------------------------------------

# Content for section - Background
# ------------------------------------------------------------------------------------------------
output$background_lc <- renderUI({
  div(class="overview-section",
      div(class="overview-section-title",  id="Background", "Background"),
      div(class="overview-section-content",
          p("Lung cancer is the forth most common cancer diagnosed and the leading cause of cancer death in Aotearoa, New Zealand."),
          p("The Lung Cancer Quality Improvement Report describes and compares the diagnosis, care and outcomes of people diagnosed with lung cancer."),
          p("This report summarises some of the key findings from the 2020 report."),
          p("It is primarily a document for healthcare professionals and service providers but people with bowel cancer and the general public may also find the data interesting. The full report, which contains more information about the methods of data collection and analysis, as well as DHB results, can be accessed at: "
          ),
          p(tags$a(style="margin-right: -5px", target="_blank", href="https://www.health.govt.nz", "https://www.health.govt.nz") )
      )
  )
})
  
  
output$indicators_lc <- renderUI({
  div(class="overview-section wide",
      div(class="overview-section-title no-line", id="Indicators", "Lung cancer indicators"),
      div(class="overview-section-content",
          indicatorTable(G_allCancerGroupsData[["lung_cancer"]])
      )
  )
})  

# Content for section - Diagnosis
# ------------------------------------------------------------------------------------------------
output$diagnosis_lc <- renderUI({
  div(class="overview-section",
      div(class="overview-section-title", id="Diagnosis", "How are people diagnosed?"),
      div(class="overview-section-content",
          p("A high proportion of people (45%) were diagnosed following a presentation to an Emergency Department. 
            They were more likely to have advanced, incurable disease than those diagnosed through clinic."),
          p("Pathological diagnosis is important for guiding treatment decisions. A pathological diagnosis identifies tumour type, but also enables molecular analysis to ascertain suitability of targeted therapies. 
            The proportion of people with a pathological diagnosis of lung cancer was high (81.4%).")
      )
  )
})

# Content for section - Characteristics (which is actually part of diagnosis)
# ------------------------------------------------------------------------------------------------
output$characteristics_lc <- renderUI({
  div(class="overview-section",
      div(class="overview-section-title", id = "Characteristics", "Characteristics of people with lung cancer"),
      div(class="overview-section-content",
          p("Lung cancer is the uncontrolled growth of abnormal cells in one or both lungs. These abnormal cells do not carry out the functions of normal lung cells and do not develop into healthy lung tissue."),
          p("There are two types of lung cancer. Each type behaves and responds to treatment differently. Small cell lung cancer (SCLC) is the type in which the cells are small and round. SCLC is often fast growing and can spread quickly.  
            On the other hand, non-small cell lung cancer (NSLC) is the most common and makes up about 70 to 80 percent of all lung cancer cases."),
          p("Over 2200 people are diagnosed with lung cancer every year in New Zealand."),
          p("The average age that a person is diagnosed with lung cancer is 70 years old."),
          p("M\u0101ori represent 16.5 percent of the general population but accounted for 22 percent of the people diagnosed with lung cancer. ")
      )
  )
})

# Content for section - Characteristics (which is actually part of diagnosis)
# ------------------------------------------------------------------------------------------------
output$characteristics_lc <- renderUI({
  div(class="overview-section",
      div(class="overview-section-title", id = "Characteristics", "Characteristics of people with lung cancer"),
      div(class="overview-section-content",
          p("Lung cancer is the uncontrolled growth of abnormal cells in one or both lungs. These abnormal cells do not carry out the functions of normal lung cells and do not develop into healthy lung tissue."),
          p("There are two types of lung cancer. Each type behaves and responds to treatment differently. Small cell lung cancer (SCLC) is the type in which the cells are small and round. SCLC is often fast growing and can spread quickly.  
            On the other hand, non-small cell lung cancer (NSLC) is the most common and makes up about 70 to 80 percent of all lung cancer cases."),
          p("Over 2200 people are diagnosed with lung cancer every year in New Zealand."),
          p("The average age that a person is diagnosed with lung cancer is 70 years old."),
          p("M\u0101ori represent 16.5 percent of the general population but accounted for 22 percent of the people diagnosed with lung cancer. ")
      )
  )
})

# Content for section - Treatment
# ------------------------------------------------------------------------------------------------
output$treatment_lc <- renderUI({
  div(class="overview-section",
      div(class="overview-section-title", id = "Treatment", "Treatment for people with lung cancer"),
      div(class="overview-section-content",
          tags$br(),
          div(class="overview-section-title no-line", "Surgery"),
          p("Surgical removal of early stage NSCLC is the primary mode of treatment, particularly those who are more fit and can independently perform certain activities of daily living. It plays an important role in decreasing morbidity and mortality. 
            The proportion of people with NSCLC who underwent curative surgical resection was 16.7%."),
          
          div(class="overview-section-title no-line", "Systemic anti-cancer therapy "),
          p("Systemic anti-cancer therapy (SACT) refers to a number of differing therapies used in malignancy to achieve palliation as well as improving symptoms, quality of life and survival. "),
          p("Timely and appropriate SACT can lead to significant improvements in symptom control, quality of life and survival for people with lung cancer. The overall receipt of systemic anti-cancer treatment for NSCLC was 29.7 compared to 71.3% for SCLC. "),
          
          div(class="overview-section-title no-line", "Radiation therapy	"),
          p("Radiation treatment treats cancer by using X-ray beams to kill cancer cells. Radiation therapy is a recommended and effective treatment option that has a proven survival benefit when lung cancer cannot be managed by surgery and has not spread outside the chest. "),
          p("Variations in the type of lung cancer, stage of the tumour, the fitness of the patient, the intention of treatment determine the type, dose and intensity of radiotherapy (e.g. radical radiotherapy, thoracic radiotherapy or stereotactic ablative radiation therapy (SABR)). The rate for those with lung cancer who received SABR were low 1.8%."),
          p("Sometimes radiation therapy can be offered in combination with chemotherapy if the aim of treatment is to try to cure the cancer. This is always referred to as concurrent chemoradiation. Overall rates of combined chemoradiation was 5.4% (5.8% for NSCLC, 10.7% for SCLC).")
      )
  )
})

# Content for section - Survival (which is actually part of diagnosis)
# ------------------------------------------------------------------------------------------------
output$survival_lc <- renderUI({
  div(class="overview-section",
      div(class="overview-section-title", id = "Survival", "Overall survival"),
      div(class="overview-section-content",
          p("Overall cancer survival is commonly accepted indicator of the effectiveness of a healthcare system. It is the percentage of people with lung cancer who are alive one, two, or three years after their diagnosis. Overall, 1-year survival in Aotearoa New Zealand (41.6%) has improved over time. ")
      )
  )
})

output$endoflife_lc <- renderUI({
  div(class="overview-section",
      div(class="overview-section-title", id = "EndOfLife", "Cancer treatment at the end-of-life  "),
      div(class="overview-section-content",
          p("People with advanced and recurrent lung cancer who have poor prognosis should not receive cancer directed treatment at the end of life. Cancer therapies should be offered only when there is a reasonable chance that it will provide a meaningful clinical benefit. Overall, 5.9% of people received chemotherapy within 30 days of death. This was higher for people with SCLC (14.3%) than NSCLC (5.9%).  ")
      )
  )
})

output$mortality_lc <- renderUI({
  div(class="overview-section",
      div(class="overview-section-title", id = "Mortality", "Treatment mortality"),
      div(class="overview-section-content",
          p("Treatment related mortality is a marker of the quality and safety of cancer care and treatment provided by the multi-disciplinary team. It is the percentage people with lung cancer who died within 30 or 90 days of treatment with curative intent (surgery, systemic anti-cancer therapy, radiation therapy). Mortality after curative intent treatment at 30 and 90 days was low.")
      )
  )
})
  
  
  
  # Generates the Indicator Overview table
  # ------------------------------------------------------------------------------------------------
  indicatorTable <- function(cgData) {
    # Top level: the table container
    
    
    
    div(class="indicator-table",
        # STEP ONE: INDICATOR SETS
        # Iterate over each set and create a block for each one
        div(class="flex-column heading-set",
            div(class="table-heading", "Indicator set"),
            lapply(unique(cgData$G_indicatorList$indicator.set), function(set) {
              div(class="table-set", div(class="set-text", set))
            })
        ),
        # STEP 2: INDICATORS
        # Iterate over each indicator and create a block for each one
        div(class="flex-column heading-indicator",
            div(class="table-heading", "Indicator"),
            lapply(unique(cgData$G_indicatorList$indicator.no), function(number) {
              # For each indicator we make a block and a line to seperate them
              tagList(
                div(class="table-line", style = "margin-left: 5px;"),
                div(class="table-indicator", unique(cgData$G_indicatorList[cgData$G_indicatorList$indicator.no == number, ]$short.description))
              )
            })
        ),
        # STEP 3: MEASURES
        # Iterate over each indicator, and for each one create a set of blocks to represent each measure the indicator has
        # Additionally, for each measure, create a block for each unique tumour site that exists for it
        div(class="flex-column heading-measure",
            div(class="table-heading", "Measure"),
            # Iterate over the indicators
            
              lapply(unique(cgData$G_indicatorList$indicator.no), function(number) {
              
                # Get a list of measures (subInds) for that indicator
                subInds <- cgData$G_indicatorList[cgData$G_indicatorList$indicator.no == number, ]
                tagList(
                  div(class="table-line", style = "margin-left: -5px;"),
                  div(class="table-measures",
                      # Now if this measure has an admission, we get each unique one and append it to its parent measure
                      if(all(!is.na(subInds$admission))){
                        # Get the unique admissions...
                        admissions <- unique(subInds$admission)
                        # ... and then for each one, get its parent measure...
                        lapply(admissions, function(adm){
                          thisAdmission <- subInds[subInds$admission == adm, ]
                          # ... and create a block for the measure with the admission appended to it (e.g: Death within 90 days of surgery - acute and elective)
                          div(class="measure-container",
                              div(class="table-measure", paste0(unique(thisAdmission$measure)[1], " - ", adm)),
                              div(class="table-tumour-container",
                                  # Also add each tumour site that exists
                                  lapply(unique(thisAdmission$tumour.site), function(ts){
                                    div(class="table-tumour", ts)
                                  })
                              )
                          )
                        })
                        # But what if there isnt an admission for the measure?
                        # Then we just iterate over each measure for the selected indicator...
                      } else {
                        measures <- unique(subInds$measure)
                        lapply(measures, function(measure){
                          
                          thisMeasure <- subInds[subInds$measure == measure, ]
                          
                          # ...Create a block for the measure...
                          div(class="measure-container",
                              tagList(
                                div(class="table-measure",unique(thisMeasure$measure)),
                                # ... and a bunch of blocks for the tumour sites
                                div(class="table-tumour-container",
                                    tagList(
                                      lapply(unique(thisMeasure$tumour.site), function(ts){
                                        div(class="table-tumour", ts)
                                      })
                                    )
                                )
                              )
                          )
                        })
                        
                      }
                  )
                )
              })
            )
    )
    # 4 to 5 levels of iteration - no problem
  }
  
}