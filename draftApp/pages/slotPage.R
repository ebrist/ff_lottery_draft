fluidPage(
  extendShinyjs(script = 'spinJS.js', functions = c("spin")),
  fluidRow(
    htmlOutput('onClock')
  ),
  div(
    style = 'height: 150px',
    tags$style("input[type=checkbox] {transform: scale(2);}"),
    tags$style("#slotSelection {font-size:18px; color: #f3f3f3;}"),
    fluidRow(
      uiOutput('slotSelectionBoxes')
    ),
    fluidRow(
      uiOutput('lockSelectionButton')
    ),
    fluidRow(
      uiOutput('displaySelection')
    )
  ),
  fluidRow(
    div(
      style = 'height: 50px;',
      uiOutput('spinSlotButton')
    )
  ),
  br(),
  tags$body(tags$div(class = 'slotwrapperhead', uiOutput('slotHead'))),
  tags$body(tags$div(class = 'slotwrapper', id = 'slotpanel', uiOutput('player_list'))),
  br(),
  br(),
  br(),
  br(),
  fluidRow(
    uiOutput('closeSlotButton')
  ),
  br(),
  br(),
  tags$body(HTML("<script src='https://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.4.1/jquery.easing.min.js'></script>")),
  includeScript("www/slotJS.js")
)
