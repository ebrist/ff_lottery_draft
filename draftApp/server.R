library(shiny)
library(shinyjs)
library(shinyWidgets)
library(data.table)
library(tidyverse)
library(knitr)
library(kableExtra)

# define server logic
shinyServer(function(input, output, session) {
  # read in the app data 
  app_data <- fread('data/mock_keeper_data.csv') %>% as_tibble()
  
  # initialize random seed with a random three digit number
  random_seed_prefix <- sample(100:999, 1)
  
  
  # dataframe containing keeper info
  keeper_data <- reactiveVal(
    app_data %>% 
      select(id, owner, team, franchise_player) %>%
      mutate(keeper1 = '', keeper2 = '', dropped = '')
  )
  # name of the active page
  active_page <- reactiveVal('homePage')
  
  # id number of the active team
  active_team <- reactiveVal(NULL)
  
  # dataframe of the random sample outcomes
  outcome_data <- reactiveVal(NULL)
  
  # true if selection is locked for slot spin
  selection_locked <- reactiveVal(F)
  
  # true if spin button is clicked
  spin_complete <- reactiveVal(F)
  
  # true if draft is complete
  draft_complete <- reactive({
    ifelse(all(keeper_data() %>% select(keeper1, keeper2, dropped) != ''), T, F)
  })
  
  # open menu page and compute the outcome data when the home page enter button is clicked
  observeEvent(input$enter_draft, {active_page('menuPage'); outcome_data(getSample())})
  
  # function returns TRUE if the team has already drafted and keepers are not empty
  # used to switch between slot page and results page when clicking on a team from the menu
  isTeamDraftComplete <- function(teamID) {
    ifelse(all(keeper_data() %>% filter(id == teamID) %>% select(keeper1, keeper2, dropped) != ''), T, F)
  }
  
  # function to render team title for the menu page
  createTeamTitle <- function(id) {
    output[[paste0("team_title", id)]] <- renderUI({
      HTML(paste0("<h3>", app_data[app_data$id == id, ]$team, "</h3>"))
    })
  }
  
  # render title for all 12 teams
  sapply(1:12, createTeamTitle)
  
  # function to render the text input for seeds
  createSeedInput <- function(id) {
    output[[paste0('input_seed', id)]] <- renderUI({
      textInput(paste0('seed', id), NULL)
    })
  }
  
  # render seed input for all 12 teams
  sapply(1:12, createSeedInput)
  
  # create the onclick action for the menu button
  createMenuAction <- function(id) {
    # open the slot page for a specific team
    observeEvent(input[[paste0("openTeam", id)]], {
      active_team(id); 
      if (isTeamDraftComplete(active_team())) {
        active_page('teamResultPage')
      } else {
        active_page('slotPage')
      } 
    })
  }
  
  # create onclick actions for all 12 menu buttons
  sapply(1:12, createMenuAction)
  
  # lock the selection
  observeEvent(input$lockSelectionButton, {
    selection_locked(T)
    keeper_data(updateKeepers(keeper_data()))
  })
  
  # on close of slot page, open menu page and reset spin count
  observeEvent(input$closeSlot, {
    active_page('menuPage')
    selection_locked(F)
    spin_complete(F)
    updateCheckboxGroupInput(session, "slotSelection", selected = NULL);
  })
  
  # return to menu page on close of team results
  observeEvent(input$closeTeamResults, {
    active_page('menuPage')
  })
  
  # go to draft result page on close of menu page
  observeEvent(input$end_draft, {
    active_page('draftResultPage.R')
  })
  
  # on spinSlot click, run the spin JS function
  # end reel 1 on player1(), reel 2 on player2(), and reel 3 on player3()
  # positions incremented by 1 due to '?' in first index
  observeEvent(input$spinSlot, {js$spin(2, 3, 4); spin_complete(T)})
  
  # set activePage based on active_page
  output$activePage <- renderUI({
    if (active_page() == 'homePage') {
      page <- source('pages/homePage.R')
    } else if (active_page() == 'menuPage') {
      page <- source('pages/menuPage.R')
    } else if (active_page() == 'slotPage') {
      page <- source('pages/slotPage.R')
    } else if (active_page() == 'teamResultPage') {
      page <- source('pages/teamResultPage.R')
    } else if (active_page() == 'draftResultPage.R') {
      page <- source('pages/draftResultPage.R')
    }
    return(page$value)
  })
  
  # generate random seed based on team inputs
  random_seed <- reactive({
    # vector of random numbers for each team to add to the seed
    seed_vec <- sapply(1:12, function(i) input[[paste0("seed", i)]])
    # drop any values not between 0-9
    seed_vec <- sapply(seed_vec, function(x) ifelse(x %in% as.character(0:9), x, ""))
    # combine into a single int
    as.numeric(paste0(random_seed_prefix, paste0(seed_vec, collapse = "")))
  })
  
  # display random seed
  output$random_seed_display <- renderUI({
    text <- paste0("<h5>", substr(random_seed(), 1, 3), " - ", substr(random_seed(), 4, 15), "</h5>")
    HTML(text)
  })
  
  # function to sample keeper data and set outcome data
  getSample <- function() {
    # set seed (seed could be as high as 999999999999999 which exceeds range of set.seed(), use sqrt for max 31622777)
    set.seed(sqrt(random_seed()))
    # randomly assign lottery players to an outcome position
    # outcome positions 1, 2, and 3 correspond to the slot positions 1: Helmet, 2: Goal Post, 3: Football
    app_data %>% 
      gather('playerNum', 'playerName', starts_with('lottery')) %>% 
      arrange(id, playerNum)%>% group_by(id) %>% 
      mutate(outcomePosition = sample(c(1, 2, 3), 3))
  }
  
  # function to create a menu button for a team
  createMenuButtons <- function(id) {
    output[[paste0("menuButtonTeam", id)]] <- renderUI({
      buttonID <- paste0('openTeam', id)
      buttonLabel <- ifelse(isTeamDraftComplete(id), 'View Results', HTML('Open Lottery'))
      buttonStyle <- ifelse(isTeamDraftComplete(id), 
                            "color: black; background-color: #2ee43b; border: 2px solid black; border-radius: 0;", 
                            "color: white; background-color: #2773d4; border: 2px solid black; border-radius: 0;")
      actionButton(buttonID, buttonLabel, style = buttonStyle)
    })
  }
  # make menu buttons for all 12 teams
  sapply(1:12, createMenuButtons)
  
  # text showing which team is on the clock and which players are on the block
  output$onClock <- renderUI({
    team <- outcome_data() %>%
      filter(id == active_team()) %>%
      pull(team) %>%
      unique()
    players <- sort(c(player1(), player2(), player3()))
    players <- paste0(players[1], ", ", players[2], ", and ", players[3])
    text <- paste0("<h1>", team, " is on the clock!</h1>",
                   "<h3>", players, " will be randomly assigned to Helmet, Goal Post, or Football</h3>")
    HTML(text)
  })
  
  # checkbox for user to select which two of three options to keep
  output$slotSelectionBoxes <- renderUI({
    if (!selection_locked()) {
      ui <- checkboxGroupInput('slotSelection', h2('Select 2 of the 3 options as your keepers'), 
                               choices = c('  Helmet  ' = 'Helmet',
                                           '  Goal Post  ' = 'Goal Post',  
                                           '  Football  ' = 'Football'),
                               inline = T)
    } else {
      ui <- NULL
    }
    
    ui
  })
  
  # force max two selections
  observe({
    if(length(input$slotSelection) > 2){
      updateCheckboxGroupInput(session, "slotSelection", selected= tail(input$slotSelection, 2))
    }
  })
  
  # render the lock selection button only if selection is not already locked and 2 selections exist
  output$lockSelectionButton <- renderUI({
    if (!selection_locked() & length(input$slotSelection) == 2) {
      ui <- actionButton('lockSelectionButton', label = "Lock Selections")
    } else {
      ui <- NULL
    }
    ui
  })
  
  # show selections once locked
  output$displaySelection <- renderUI({
    if (selection_locked()) {
      ui <- HTML(paste('<h2>You selected ', paste0(paste0("<g>", input$slotSelection, "</g>"), collapse = ' and '), 
                       ' as your keepers!<br><br>Click the Spin button to run the slot machine</h2>'))
    } else {
      ui <- NULL
    }
    ui
  })
  
  updateKeepers <- function(data) {
    players <- c(player1(), player2(), player3())
    keeperIDs <- c(ifelse('Helmet' %in% input$slotSelection, 1, NA),
                   ifelse('Goal Post' %in% input$slotSelection, 2, NA),
                   ifelse('Football' %in% input$slotSelection, 3, NA))
    keeperIDs <- keeperIDs[!is.na(keeperIDs)]
    data[data$id == active_team(), ][['keeper1']] <- players[keeperIDs[1]]
    data[data$id == active_team(), ][['keeper2']] <- players[keeperIDs[2]]
    data[data$id == active_team(), ][['dropped']] <- players[!players %in% c(players[keeperIDs[1]], 
                                                                           players[keeperIDs[2]])]
    # return data
    data
  }
  
  # player selected in first column
  player1 <- reactive({
    player_data <- outcome_data() %>%
      filter(id == active_team(), outcomePosition == 1)
    player_data$playerName
  })
  
  # player selected in second column
  player2 <- reactive({
    player_data <- outcome_data() %>%
      filter(id == active_team(), outcomePosition == 2)
    player_data$playerName
  })
  
  # player selected in third column
  player3 <- reactive({
    player_data <- outcome_data() %>%
      filter(id == active_team(), outcomePosition == 3)
    player_data$playerName
  })
  
  # player list for the slot machine
  output$player_list <- renderUI({
    # if player name is longer than 12 chars, add '...' in place of chars > 12
    p1 <- ifelse(nchar(player1()) <= 12, player1(), paste0(substr(player1(), 1, 12), '...'))
    p2 <- ifelse(nchar(player2()) <= 12, player2(), paste0(substr(player2(), 1, 12), '...'))
    p3 <- ifelse(nchar(player3()) <= 12, player3(), paste0(substr(player3(), 1, 12), '...'))
    # vector of the three players with '?' in first index to hide players before the spin
    players <-  c("?", p1, p2, p3)
    
    # reel colors
    hColor <- ifelse('Helmet' %in% input$slotSelection, 'g', 'r')
    gColor <- ifelse('Goal Post' %in% input$slotSelection, 'g', 'r')
    fColor <- ifelse('Football' %in% input$slotSelection, 'g', 'r')
    
    # format lists ul + li + reel color
    playersH <- tags$ul(sapply(players, function(x) tags$li(HTML(paste0("<", hColor, ">", x, "</", hColor, ">"))), 
                               simplify = F, USE.NAMES = F))
    playersG <- tags$ul(sapply(players, function(x) tags$li(HTML(paste0("<", gColor, ">", x, "</", gColor, ">"))), 
                               simplify = F, USE.NAMES = F))
    playersF <- tags$ul(sapply(players, function(x) tags$li(HTML(paste0("<", fColor, ">", x, "</", fColor, ">"))), 
                               simplify = F, USE.NAMES = F))
    
    # return list of lists
    list(playersH, playersG, playersF)
  })
  
  # the header of the slot machine (three png images)
  output$slotHead <- renderUI({
    icon1 <- tags$ul(img(src='helmet.png', align = "center", width="80", height="80"))
    icon2 <- tags$ul(img(src='goalpost.png', align = "center", width="80", height="80"))
    icon3 <- tags$ul(img(src='football.png', align = "center", width="80", height="80"))
    list(icon1, icon2, icon3)
  })
  
  # render the spin button only if spin count is zero and selections are locked
  output$spinSlotButton <- renderUI({
    if (!spin_complete() & selection_locked()) {
      ui <- actionButton("spinSlot", label = 'Spin', class = 'btn btn-success')
    } else {
      ui <- NULL
    }
    ui
  })
  
  output$closeSlotButton <- renderUI({
    if (spin_complete()) {
      ui <- actionButton('closeSlot', "Save & Close")
    } else {
      ui <- NULL
    }
    ui
  })
  
  output$endDraftButton <- renderUI({
    if (draft_complete()) {
      ui <- actionButton('end_draft', "End Draft")
    } else {
      ui <- NULL
    }
    ui
  })
  
  output$teamResultText <- renderUI({
    team_data <- keeper_data() %>%
      filter(id == active_team())
    print(team_data)
    
    HTML(paste0("<br><h2>", team_data$team, " Lottery Draft Results<br><br><br>",
                "Keepers<br><br><g>", team_data$keeper1, "</g> and <g>", team_data$keeper2, "</g><br><br><br>",
                "Dropped to Free Agency<br><br><r>", team_data$dropped, "</r><br><br>"))
  })
  
  output$closeTeamResultsButton <- renderUI({
    actionButton('closeTeamResults', 'Close')
  })
  
  output$display_result_table <- function() {
    keeper_data() %>%
      select(Team = team, `Franchise Player` = franchise_player,
             `Keeper 1` = keeper1, `Keeper 2` = keeper2, `Dropped to FA` = dropped) %>%
      kable(format = 'html') %>%
      kable_styling(full_width = F, font_size = 16) %>%
      row_spec(0, color = 'white', bold = T) %>%
      column_spec(1, color = 'white', bold = T) %>%
      column_spec(2, color = '#2773d4', bold = T) %>%
      column_spec(3:4, color = '#2ee43b', bold = T) %>%
      column_spec(5, color = '#ff3333', bold = T)
  }
  
   output$download_result_table <- downloadHandler(
    filename = function() {
      paste0('draft_results_', Sys.Date(), '.csv', sep='')
    },
    content = function(con) {
      fwrite(keeper_data() %>% select(-id), con)
    }
  )
  
})