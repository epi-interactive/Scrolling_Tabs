pageOverviewUI <- function(id) {
  ns <- NS(id)
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
}