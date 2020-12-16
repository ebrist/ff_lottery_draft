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
      fluidRow(uiOutput('team_title1')),
      fluidRow(uiOutput('menuButtonTeam1'))
    ),
    column(3, align = 'center',
      fluidRow(uiOutput('team_title2')),
      fluidRow(uiOutput('menuButtonTeam2'))
    ),
    column(3, align = 'center',
      fluidRow(uiOutput('team_title3')),
      fluidRow(uiOutput('menuButtonTeam3'))
    ),
    column(3, align = 'center',
      fluidRow(uiOutput('team_title4')),
      fluidRow(uiOutput('menuButtonTeam4'))
    )
  ), 
  fluidRow(
    column(3, align = 'center',
      fluidRow(uiOutput('team_title5')),
      fluidRow(uiOutput('menuButtonTeam5'))
    ),
    column(3, align = 'center',
      fluidRow(uiOutput('team_title6')),
      fluidRow(uiOutput('menuButtonTeam6'))
    ),
    column(3, align = 'center',
      fluidRow(uiOutput('team_title7')),
      fluidRow(uiOutput('menuButtonTeam7'))
    ),
    column(3, align = 'center',
      fluidRow(uiOutput('team_title8')),
      fluidRow(uiOutput('menuButtonTeam8'))
    )
  ),
  fluidRow(
    column(3, align = 'center',
      fluidRow(uiOutput('team_title9')),
      fluidRow(uiOutput('menuButtonTeam9'))
    ),
    column(3, align = 'center',
      fluidRow(uiOutput('team_title10')),
      fluidRow(uiOutput('menuButtonTeam10'))
    ),
    column(3, align = 'center',
      fluidRow(uiOutput('team_title11')),
      fluidRow(uiOutput('menuButtonTeam11'))
    ),
    column(3, align = 'center',
      fluidRow(uiOutput('team_title12')),
      fluidRow(uiOutput('menuButtonTeam12'))
    ) 
  ),
  br(),
  br(),
  fluidRow(
    uiOutput('endDraftButton')
  )
)
