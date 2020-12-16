#This file is effectively static methods for returning frequently used HTML.
#There should be no state, everything here is considered immutable.
createCancerGroupPage <- function(id, content, name, header = F) {
  
  headerHTML <- NULL
  
  tagList(
    div(class="wrapper",
        div(class="navPage",
            headerHTML,
            div(id=id, class="flex-page",
                div(class="flex-page-row",
                    div(style = "width: 100%;",
                        content
                    )
                )
            )
        )
    )
  )
}


createFlexSidebarPage <- function(id, sidecontent, mainContent, name, header=F){
  sidebar <- NULL
  headerHTML <- NULL
  if(!is.null(sidecontent)){
    sidebar <- div(class="flex-sidebar",
                   sidecontent
                   )
  }
  tagList(
    div(class="wrapper",
        div(class="navPage",
            headerHTML,
            div(id=id, class="flex-page",
                div(class="flex-page-row",
                    sidebar,
                    div(class=if(!is.null(sidebar)){"container-fluid flex-main"}else "flex-main",
                        mainContent
                    )
                )
            )
        )
    )
  )
}

createFlexPage <- function(id, mainContent, name, header=F){
  createFlexSidebarPage(id, NULL, mainContent, name, header)
}


createFilterGroup <- function(id, ..., accordian=F){
  children <- list(...)
  if(accordian){
    children <- lapply(children, function(child){
      child$children[[1]] <- htmltools::tagAppendAttributes(child$children[[1]], "data-parent"=paste0("#", id))
      child
    })
  }
  
  div(class="fixed-scroll-wrapper", 
    fluidRow(class="content-pad-30",
             column(12, class="sidebar-filters",
                    div(class="filter-group", id=id,
                        tagList(children)
                    )
                    
             )
    )
  )
}

createFilterPanel <- function(id, title, ..., collapsed=FALSE, interactive=TRUE){
  cls <- "filter-title"
  if(collapsed){cls <- paste(cls, "collapsed")}
  if(interactive){cls <- paste(cls, "interactive")}
  
  div(class="panel filter-panel sidebar-underline",
      div(class=cls,
          'data-toggle'=if(interactive)"collapse", 'data-target'=if(interactive)paste0("#", id),
          title
      ),
      div(class=if(collapsed && interactive)"filter-body collapse" else "filter-body collapse in", id=id,
          tagList(...)
      )
  )
}

createNavbar <- function(currentPage){
  
  items <- c()
  for (num in 1:length(headerLinks)) {
    pg <- headerLinks[[num]]
    pgName <- names(headerLinks[num])
    
    if(typeof(pg) == "list") {
      # construct a drop-down
      subpages <- pg
      
      isSubPageActive <- ""
      
      subitems <- lapply(subpages, function(spg) {
        
        spgName <- names(subpages)[subpages == spg]
        if(spgName==currentPage) {
          cls <- " class = 'active'>"
          isSubPageActive <<- "active"
        }
        else {
          cls <- ">"
        }
        t <- HTML(paste0("<li", cls, "<a href = '#' onclick = 'Shiny.setInputValue(\"", subpages[[spgName]], "\", Math.random()); return false;'>", spgName, "</a></li>"))
      })
      
      subitems <- unlist(unname(subitems))
      
      
      out <- div(class = paste0("nav-dropdown ", isSubPageActive),
                 tags$li(tags$a(paste0(pgName, " \u25BC"))),
                 div(class = "nav-dropdown-content",
                     tagList(HTML(subitems))
                 )
      )
    }
    else {
      # regular page link
      cls <- if(pgName==currentPage) "active" else ""
      out <- tags$li(class=cls, tags$a(href="#", onclick = paste0("Shiny.setInputValue('", pg, "', Math.random()); return false;"), pgName))
    }
    
    items <- tagList(items, out)
  }
  
  tags$nav(class="navbar navbar-default navbar-moh",
           div(class="navbar-header",
               tags$button(class="navbar-toggle collapsed", "type"="button",
                           "data-toggle"="collapse", "data-target"="#navbar-collapsable", "aria-expanded"="false",
                           span(class="sr-only", "Toggle navigation"),
                           span(class="icon-bar", ""), span(class="icon-bar", ""), span(class="icon-bar", "") #3 bars, burger icon
               )
           ),
           div(class="collapse navbar-collapse", id="navbar-collapsable",
               tags$ul(class="nav navbar-nav navbar-small",
                       tagList(items)
               )
           )
  )
}




