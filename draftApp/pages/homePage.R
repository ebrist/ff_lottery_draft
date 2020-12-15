fluidPage(
  fluidRow(HTML(paste0("<h1>Welcome to the League of Leatherheads Lottery Draft</h1>",
                       "<h2>Each team has the option to contribute to the random seed ",
                       "to ensure a fair draft<br><br>",
                       "Enter a number between 0 and 9</h2>"))),
  fluidRow(
    column(3, align = 'center',
      fluidRow(uiOutput('team_title1')),
      fluidRow(textInput('seed1', NULL, width = '50px'))
    ),
    column(3, align = 'center',
      fluidRow(uiOutput('team_title2')),
      fluidRow(textInput('seed2', NULL, width = '50px'))
    ),
    column(3, align = 'center',
      fluidRow(uiOutput('team_title3')),
      fluidRow(textInput('seed3', NULL, width = '50px'))
    ),
    column(3, align = 'center',
      fluidRow(uiOutput('team_title4')),
      fluidRow(textInput('seed4', NULL, width = '50px'))
    )
  ),
  fluidRow(
    column(3, align = 'center',
      fluidRow(uiOutput('team_title5')),
      fluidRow(textInput('seed5', NULL, width = '50px'))
    ),
    column(3, align = 'center',
      fluidRow(uiOutput('team_title6')),
      fluidRow(textInput('seed6', NULL, width = '50px'))
    ),
    column(3, align = 'center',
      fluidRow(uiOutput('team_title7')),
      fluidRow(textInput('seed7', NULL, width = '50px'))
    ),
    column(3, align = 'center',
      fluidRow(uiOutput('team_title8')),
      fluidRow(textInput('seed8', NULL, width = '50px'))
    )
  ),
  fluidRow(
    column(3, align = 'center',
      fluidRow(uiOutput('team_title9')),
      fluidRow(textInput('seed9', NULL, width = '50px'))
    ),
    column(3, align = 'center',
      fluidRow(uiOutput('team_title10')),
      fluidRow(textInput('seed10', NULL, width = '50px'))
    ),
    column(3, align = 'center',
      fluidRow(uiOutput('team_title11')),
      fluidRow(textInput('seed11', NULL, width = '50px'))
    ),
    column(3, align = 'center',
      fluidRow(uiOutput('team_title12')),
      fluidRow(textInput('seed12', NULL, width = '50px'))
    ) 
  ),
  br(),
  fluidRow(
    HTML("<h3>Random Seed</h3>")
  ),
  fluidRow(
    htmlOutput('random_seed_display')
  ),
  br(),
  fluidRow(
    actionButton('enter_draft', 'Enter Draft')
  )
)