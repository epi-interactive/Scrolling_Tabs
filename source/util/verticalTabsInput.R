library(stringr)

verticalTabsInput <- function(inputId, tabs, active=NULL) {
  elems <- as.list(tabs)
  
  if(is.null(active)){
    active <- elems[[1]]
  }

  items <- list()
  for(num in 1:length(elems)) {
    elem <- elems[[num]]
    
    if(typeof(elem) == "list") {
      elemName <- names(elems)[num]
      
      subitems <- lapply(elem, function(x) {
        div(class=paste("vertical-tab", if(x==active){"active"}),
                    x
                )
      })
      
      G_NZ_towns <- list(
        "North island towns" = "North_island_towns",
        "South island towns" = "South_island_towns",
        "New Zealand Map"    = "new_zealand_section"
      )
      
      item_id <- G_NZ_towns[names(G_NZ_towns) == elemName]
      
      items[[num]] <- div(class = "vt-dropdown", 
                          div(id = item_id, class=paste("vertical-tab", if(elemName==active){"active"}),
                              onclick = paste0("toggleVerticalTabDropdown('", item_id, "', true);"),
                              elemName,
                              img(class="dpArrow",src= "img/arrow.png")
                          ),
          div(class = "vt-dropdown-content",
              style = "display: none;",
              subitems
              )
          )
    }
    else {
      items[[num]] <- div(class=paste("vertical-tab", if(elem==active){"active"}),
                          onclick = paste0("toggleVerticalTabDropdown('", str_to_lower(elem), "', true);"),
                          elem
              )
    }
  }
  div(class="vertical-tab-binding", id=inputId,
      items,img(class="tab-logo",src= "img/Epi_Logo_PoweredBy_HZ_Outline_RGB_REV-01.png")
  )
}