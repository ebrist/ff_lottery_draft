fluidPage(
  fluidRow(
    HTML("<h1>The Draft is Open!</h1>")
  ),
  br(),
  fluidRow(
    HTML("<h2>Select a Team to Open the Lottery</h2>")
  ),
  br(),
  fluidRow(
    column(3, align = 'center',
      fluidRow(HTML(paste0("<h3>", app_data[app_data$id == 1, ]$team, "</h3>"))),
      uiOutput('menuButtonTeam1')
    ),
    column(3, align = 'center',
      fluidRow(HTML(paste0("<h3>", app_data[app_data$id == 2, ]$team, "</h3>"))),
      uiOutput('menuButtonTeam2')
    ),
    column(3, align = 'center',
      fluidRow(HTML(paste0("<h3>", app_data[app_data$id == 3, ]$team, "</h3>"))),
      uiOutput('menuButtonTeam3')
    ),
    column(3, align = 'center',
      fluidRow(HTML(paste0("<h3>", app_data[app_data$id == 4, ]$team, "</h3>"))),
      uiOutput('menuButtonTeam4')
    )
  ),
  fluidRow(
    column(3, align = 'center',
      fluidRow(HTML(paste0("<h3>", app_data[app_data$id == 5, ]$team, "</h3>"))),
      uiOutput('menuButtonTeam5')
    ),
    column(3, align = 'center',
      fluidRow(HTML(paste0("<h3>", app_data[app_data$id == 6, ]$team, "</h3>"))),
      uiOutput('menuButtonTeam6')
    ),
    column(3, align = 'center',
      fluidRow(HTML(paste0("<h3>", app_data[app_data$id == 7, ]$team, "</h3>"))),
      uiOutput('menuButtonTeam7')
    ),
    column(3, align = 'center',
      fluidRow(HTML(paste0("<h3>", app_data[app_data$id == 8, ]$team, "</h3>"))),
      uiOutput('menuButtonTeam8')
    )
  ),
  fluidRow(
    column(3, align = 'center',
      fluidRow(HTML(paste0("<h3>", app_data[app_data$id == 9, ]$team, "</h3>"))),
      uiOutput('menuButtonTeam9')
    ),
    column(3, align = 'center',
      fluidRow(HTML(paste0("<h3>", app_data[app_data$id == 10, ]$team, "</h3>"))),
      uiOutput('menuButtonTeam10')
    ),
    column(3, align = 'center',
      fluidRow(HTML(paste0("<h3>", app_data[app_data$id == 11, ]$team, "</h3>"))),
      uiOutput('menuButtonTeam11')
    ),
    column(3, align = 'center',
      fluidRow(HTML(paste0("<h3>", app_data[app_data$id == 12, ]$team, "</h3>"))),
      uiOutput('menuButtonTeam12')
    ) 
  ),
  br(),
  br(),
  fluidRow(
    uiOutput('endDraftButton')
  )
)
