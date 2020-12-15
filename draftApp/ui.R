library(shiny)
library(shinyjs)
library(shinyWidgets)
library(data.table)
library(tidyverse)
library(knitr)
library(kableExtra)

# primary ui
shinyUI(
  fluidPage(
    useShinyjs(),
    includeCSS("www/mycss.css"),
    setBackgroundImage(
      src = "background.jpg"
    ),
    column(2),
    column(8,  align = 'center',
      div(
        style = 'background-color: #000000b8; padding: 10px; min-width: 900px;',
        uiOutput("activePage")
      )
    ),
    column(2)
  )
)