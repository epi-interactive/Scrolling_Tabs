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





