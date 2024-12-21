library(shiny)
library(shinyMobile)
library(shinyWidgets)
library(dplyr)
library(DT)
library(shinyjs)
library(digest) 
#library(jump2pwa)
source("jump2pwa.R")

#library(shiny.pwa)

#### Sample data for users####
users <- readRDS("users.rds")
guides <- readRDS("guides.rds")
credentials <- readRDS("credentials.rds")
pending_requests <- reactiveVal(readRDS("pending_requests.rds"))

#### Custom CSS for styling with improved spacing and padding####
custom_css <- "
  body, .page-content {
    transition: all 0.3s ease;
    padding-left: 20px;
    padding-right: 20px;
    font-size: 12px;  /* Global font size adjustment */
  }
  .form-row {
    display: flex;
    align-items: center;
    margin-bottom: 20px;
  }
  .form-label {
    flex: 1;
    margin-right: 10px;
     font-size: 12px;
  }
  .form-input {
    flex: 2;
  }
  .btn-space {
    margin-bottom: 20px;
    width: 100%;
  }
  .full-width {
    width: 100% !important;
  }
  .spaced-input {
    margin-bottom: 20px;
  }
  .card {
    background-color: #444444 !important;
    color: white !important;
    padding: 20px;
  }
  body.light-mode .card {
    background-color: #F0F0F0 !important;
    color: black !important;
    padding: 20px;
  }
  body.dark-mode, .page-content.dark-mode {
    background-color: #2E3B4E !important;
    color: white !important;
  }
  body.light-mode, .page-content.light-mode {
    background-color: #FFFFFF !important;
    color: black !important;
  }
  .shiny-input-container input {
    border: 1px solid white !important;
    color: white !important;
     font-size: 14px !important;  /* Set a normal font size for input fields */
  }
  body.light-mode .shiny-input-container input {
    border: 1px solid black !important;
    color: black !important;
  }
  .btn-space {
    margin-bottom: 20px;
    width: 100%;
  }
  .full-width {
    width: 100% !important;
  }
  .spacing {
    margin-bottom: 20px;
  }
  .spaced-label {
    margin-bottom: 5px;
  }
  .spaced-input {
    margin-bottom: 20px;
  }
  table.dataTable tbody tr {
    background-color: #2E3B4E !important;
    color: white !important;
  }
  table.dataTable thead th {
    background-color: #2E3B4E !important;
    color: white !important;
  }
  body.light-mode table.dataTable tbody tr {
    background-color: #FFFFFF !important;
    color: black !important;
  }
  body.light-mode table.dataTable thead th {
    background-color: #FFFFFF !important;
    color: black !important;
  }
  .dataTables_length, .dataTables_filter, .dataTables_info, .dataTables_paginate {
    color: white !important;
  }
  body.light-mode .dataTables_length, body.light-mode .dataTables_filter, body.light-mode .dataTables_info, body.light-mode .dataTables_paginate {
    color: black !important;
  }
  .dataTables_wrapper .dataTables_paginate .paginate_button {
    color: white !important;
  }
  body.light-mode .dataTables_wrapper .dataTables_paginate .paginate_button {
    color: black !important;
  }
  .dataTables_wrapper .dataTables_paginate .paginate_button.disabled {
    color: grey !important;
  }
  .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
    color: white !important;
  }
  body.light-mode .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
    color: black !important;
  }
  
  
  
  .dataTables_wrapper .dataTables_filter input {
    color: black !important;
  }
  .dataTables_filter input {
    background-color: white !important;
    color: black !important;
    border: 1px solid white !important;
  }
  body.light-mode .dataTables_filter input {
    background-color: black !important;
    color: white !important;
    border: 1px solid black !important;
    font-size: 14px !important;  /* Set a normal font size for filter input */
  }

  /* Additional CSS for container background */
  .card {
    background-color: #444444 !important; /* Dark gray background for dark mode */
    color: white !important;
    padding: 20px;
  }
  body.light-mode .card {
    background-color: #F0F0F0 !important; /* Lighter gray background for light mode */
    color: black !important;
    padding: 20px;
  }
  /* Ensure the DataTable is responsive */
  .dataTables_wrapper {
    width: 100%;
    overflow-x: auto;
  }

  table.dataTable {
    width: 100% !important;
    margin: 0 auto;
    font-size: 12px;  /* Smaller font size for table text */
  }

  table.dataTable thead th,
  table.dataTable tbody td {
    white-space: nowrap;
  }
   .f7-button, .btn {
    font-size: 12px !important;  /* Ensure buttons have slightly larger text */
   }
    .navbar, .footer, .header {
    font-size: 12px;  /* Adjust font size for navigation, footer, and headers */
    }
    
   h1, h2, h3, h4, h5, h6 {
    font-size: 90%;  /* Adjust headings proportionally */
   }
  
  /* CSS specifically for accept/reject buttons */
  .btn-accept, .btn-reject {
    margin-right: 5px;
    width: 60px !important;  /* Adjust the width to fit within the table cell */
  }
  .dt-center {
    text-align: center !important;  /* Center the buttons within their column */
  }
   /* Make the columns narrower */
  table.dataTable thead th,
  table.dataTable tbody td {
    white-space: normal !important;  /* Allow text to wrap within cells */
    word-wrap: break-word !important;  /* Break long words if needed */
    vertical-align: top;  /* Align text to the top of each cell */
    width: 80px;  /* Set a fixed width for the columns */
  }
"



#### Define the tab UI components as constants####
login_register_tab <- f7Tab(
  tabName = "LoginRegister",
  icon = f7Icon("person"),
  active = TRUE,
  hidden = TRUE,
  div(id = "loginRegisterTab",
      f7Card(
        div(
          textInput("email", "Email"),
          div(
            passwordInput("password", "Password"),
            class = "spacing"
          ),
          div(
            f7Button(inputId = "login", label = "Login"),
            class = "btn-space"
          ),
          div(
            f7Button(inputId = "showRegister", label = "Register"),
            class = "full-width"
          )
        )
      )
  )
)

register_tab <- f7Tab(
  tabName = "Register",
  icon = f7Icon("person_add"),
  active = FALSE,
  hidden = TRUE,
  f7Card(
    div(
      h4("Register"),
      selectInput("regRole", "Register as", choices = c("chose one","Tourist", "Guide")),
      textInput("regName", "Name"),
      textInput("regEmail", "Email"),
      textInput("regLanguage", "Language"),
      
      uiOutput("dynamicFields"),
      div(
        passwordInput("regPassword", "Password"),
        class = "spacing"
      ),
      div(
        f7Button(inputId = "register", label = "Register"),
        class = "full-width",
        class = "btn-space"
      )
    )
  )
)

search_tab <- f7Tab(
  tabName = "Search",
  hidden = FALSE,
  active = FALSE,
  icon = f7Icon("search"),
  f7Card(
    div(
      h4("Search Guides"),
      div(
        DTOutput("searchResults")
      ),
      # Nur für Touristen sichtbar
      uiOutput("requestButtonUI")
    )
  )
)

settings_tab <- f7Tab(
  tabName = "Settings",
  icon = f7Icon("gear"),
  active = FALSE,
  hidden = FALSE,
  f7Card(
    div(
      h4("Settings"),
      f7Tabs(
        id = "settings_tabs",
        f7Tab(
          tabName = "AppSettings",
          icon = f7Icon("paintbrush"),
          active = TRUE,
          f7Card(
            div(
              h4("App Settings"),
              f7Toggle(
                inputId = "themeToggle",
                label = "Dark Mode",
                color = "blue",
                checked = FALSE
              )
            )
          )
        ),
        f7Tab(
          tabName = "AppInfo",
          icon = f7Icon("info_circle"),
          active = FALSE,
          f7Card(
            div(
              h4("App Information"),
              p("This app connects tourists with guides.")
            )
          )
        )
      )
    )
  )
)

profile_tab <- f7Tab(
  tabName = "Profile",
  icon = f7Icon("person"),
  active = FALSE,
  hidden = TRUE,
  f7Card(
    f7Tabs(
      id = "profile_tabs",
      f7Tab(
        tabName = "EditProfile",
        icon = f7Icon("pencil"),
        active = TRUE,
        div(
          h4("Edit Profile"),
          
          # Name field
          div(class = "form-row",
              tags$label("Name", class = "form-label"),
              tags$input(type = "text", id = "editName", value = "", class = "form-control form-input", disabled = "disabled")
          ),
          
          # Email field
          div(class = "form-row",
              tags$label("Email", class = "form-label"),
              tags$input(type = "text", id = "editEmail", value = "", class = "form-control form-input", disabled = "disabled")
          ),
          
          # Dynamically render fields based on role
          uiOutput("dynamicProfileFields"),
          
          # Save Changes button
          div(
            f7Button(inputId = "saveProfile", label = "Save Changes"),
            style = "margin-bottom: 20px; width: 100%;"
          )
        )
      ),
      f7Tab(
        tabName = "Requests",
        icon = f7Icon("calendar"),
        active = FALSE,
        div(
          h4("Your Requests"),
          DTOutput("profileRequests")
        )
      )
    ),
    div(
      f7Button(inputId = "logout", label = "Logout"),
      style = "width: 100%;"
    )
  )
)

appointment_form <- f7Tab(
  tabName = "Appointment",
  icon = f7Icon("calendar"),
  active = FALSE,
  f7Card(
    h4("Request Appointment with John Doe"),
    
    div(style = "margin-bottom: 10px; font-weight: bold; color: #007aff;", 
        "Please select a date from the calendar below."),
    
    # Date picker for selecting date
    f7DatePicker(
      inputId = "appointmentDate",
      label = "Click Here to Select Date",
      value = Sys.Date(),
      openIn = "sheet",
      dateFormat = "yyyy-mm-dd"
    ),
    
    # Time input
    textInput("appointmentTime", "Select Time (e.g., 10:00)", value = "10:00"),
    
    # Confirm Appointment Button
    f7Button(
      inputId = "confirmAppointment", 
      label = "Request Appointment",  
      color = "blue", 
      size = "small",
      
    )
  )
)









#### UI definition####
ui <- f7Page(
  #allowPWA = TRUE,
  useShinyjs(),
  title = "TourGuideConnect",
  # Add custom CSS in the head
  tags$head(
    tags$style(HTML(custom_css)),
    tags$link(rel = "manifest", href = "/www/manifest.json"),
    tags$script(HTML("
      if ('serviceWorker' in navigator) {
        navigator.serviceWorker.register('service-worker.js')
          .then(function(registration) {
            console.log('Service Worker registered with scope:', registration.scope);
          })
          .catch(function(error) {
            console.log('Service Worker registration failed:', error);
          });
      }
    "))
  ),
  setup_pwa(
                 # Directory where manifest.json and service-worker.js will be saved
    pwa_name = "My Shiny PWA",        # The name of the PWA
    short_name = "ShinyPWA",          # Shorter name for the PWA (for home screen)
    start_url = "/",                  # The start URL of the PWA (usually "/")
    display = "standalone",           # Display mode: standalone, fullscreen, minimal-ui, browser
    orientation = "portrait",         # Lock the app in portrait mode
    background_color = "#ffffff",     # Splash screen background color
    theme_color = "#000000",          # Theme color for the app's UI
    icons = list(                     # Icons to include in the manifest
      list(src = "www/icon.png", sizes = "192x192", type = "image/png"),
      list(src = "www/icon_maskable.png", sizes = "512x512", type = "image/png")
    ),
    cache_name = "shiny-pwa-cache-v1",  # Name of the cache
    assets = c("/", "/index.html", "/css/style.css", "/js/app.js"),  # Assets to cache
    caching_strategy = "cache-first",   # Caching strategy (cache-first, network-first, etc.)
    #enable_background_sync = TRUE,      # Enable background sync
    #enable_push_notifications = TRUE    # Enable push notifications
    path = "www",
    lang="en"
    ),
  
  # Properly pass the f7TabLayout as an argument to f7Page
  f7TabLayout(
    navbar = f7Navbar(
      title = "TourGuideConnect",
      hairline = FALSE,
      shadow = FALSE
    ),
    f7Tabs(
      animated = TRUE,
      id = "tabs",
      login_register_tab,
      register_tab,
      search_tab,
      settings_tab
    )
  )
)


#### Server logic####
server <- function(input, output, session) {
  # Reactive values for user login state and current user
  userLoggedIn <- reactiveVal(FALSE)
  currentUser <- reactiveVal(NULL)
  searchResults <- reactiveVal(guides) # Initialize with full guides data
  selectedGuide <- reactiveVal(NULL)
  currentUser <- reactiveVal(NULL)
  
  role <- reactiveVal("")
  # Call functions to generate PWA files
  #generate_manifest()
  #generate_service_worker()
  
  ####Test mode####
  Sys.setenv(TEST_MODE = "false")
  
  observe({
    if (Sys.getenv("TEST_MODE") == "true") {
      #test_email <- "alice.jones@example.com"
     test_email <- "emily.johnson@example.com"
      
      test_password <- digest("password123", algo = "sha256")
      
      user <- credentials %>% filter(email == test_email & password == test_password)
      
      if (nrow(user) == 1) {
        guide_name <- guides %>% filter(email == test_email) %>% pull(name)
        currentUser(cbind(user, name = guide_name))
        
        userLoggedIn(TRUE)
        showNotification("Automatisch eingeloggt als michael.brown@example.com.", type = "message", duration = 2)
        updateF7Tabs(session, id = "tabs", selected = "Profile")
      } else {
        showNotification("Fehler beim automatischen Login.", type = "error")
      }
    }
  })
  
  #### Update the role immediately after selection####
  observe({
    req(input$regRole)
    if (!input$regRole=="chose one"){
      role(input$regRole)  
    }else{
      role(currentUser()$role)
    }
  })
  observeEvent(userLoggedIn(), {
    if (userLoggedIn() && !is.null(currentUser())) {
      role(currentUser()$role)  
      
    }
  })
  observe({
    if (userLoggedIn()) {
      updateF7Tabs(session, id = "tabs", selected = "Profile")
    }
  })
  
  ####Dark mode####
  observeEvent(input$themeToggle, {
    if (input$themeToggle) {
      shinyjs::addClass(selector = "body", class = "dark-mode")
      shinyjs::removeClass(selector = "body", class = "light-mode")
    } else {
      shinyjs::addClass(selector = "body", class = "light-mode")
      shinyjs::removeClass(selector = "body", class = "dark-mode")
    }
  })
  
  #### Insert or remove tabs based on user login status ####
  observe({
    if (userLoggedIn()) {
      removeF7Tab(id = "tabs", target = "LoginRegister", session = session)
      removeF7Tab(id = "tabs", target = "Register", session = session)
      insertF7Tab(id = "tabs", tab = profile_tab, target = "Search", position = "before", session = session)
    } else {
      insertF7Tab(id = "tabs", tab = login_register_tab, target = "Search", position = "before", session = session)
      shinyjs::show("loginRegisterTab")
      removeF7Tab(id = "tabs", target = "Profile", session = session)
      updateF7Tabs(session, id = "tabs", selected = "LoginRegister")
    }
  })
  
  #### Show register tab ####
  observeEvent(input$showRegister, {
    updateF7Tabs(session, id = "tabs", selected = "Register")
  })
  
  #### Register a new user ####
  observeEvent(input$register, {
    
    if (input$regName == "" || input$regEmail == "" || input$regPassword == "" || input$regLanguage == "" || (role() == "Guide" && (input$regLocation == "" || input$regExpertise == "" || is.null(input$regPrice) ))) {
      showNotification("Bitte füllen Sie alle erforderlichen Felder aus.", type = "error", duration = 5)
      return()  
    }
    
    if (nchar(input$regPassword) < 10 ||  
        !grepl("[A-Z]", input$regPassword) ||  
        !grepl("[a-z]", input$regPassword) ||  
        !grepl("[0-9]", input$regPassword) ||  
        !grepl("[^a-zA-Z0-9]", input$regPassword)) {  
      showNotification("Das Passwort muss mindestens 10 Zeichen lang sein und mindestens einen Großbuchstaben, einen Kleinbuchstaben, eine Zahl und ein Sonderzeichen enthalten.", type = "error", duration = 5)
      return()  
    }
    req(role()) 
    new_user <- data.frame(
      name = input$regName,
      email = input$regEmail,
      #role = role(),
      language = input$regLanguage,
      location = ifelse(role() == "Guide", input$regLocation, NA),
      expertise = ifelse(role() == "Guide", input$regExpertise, NA),
      rating = ifelse(role() == "Guide", 0, NA),
      price = ifelse(role() == "Guide", input$regPrice, NA),
      stringsAsFactors = FALSE
    )
    
    new_user <- new_user[, colSums(is.na(new_user)) == 0]
    
    if (role() == "Tourist") {
      users <<- rbind(users, new_user)
      saveRDS(users, "users.rds")
    } else if (role() == "Guide") {
      guides <<- rbind(guides, new_user)
      saveRDS(guides, "guides.rds")
    }
    
    new_credential <- data.frame(
      email = input$regEmail,
      password = digest(input$regPassword, algo = "sha256"),  
      role = role(),
      stringsAsFactors = FALSE
    )
    credentials <<- rbind(credentials, new_credential)
    saveRDS(credentials, "credentials.rds")
    
    currentUser(
      list(
        name = input$regName,
        email = input$regEmail,
        role = role()
      )
    )
    
    userLoggedIn(TRUE)
    updateF7Tabs(session, id = "tabs", selected = "Profile")
  })
  
  output$dynamicFields <- renderUI({
    req(role())  # Stelle sicher, dass role() gesetzt ist
    
    if (role() == "Guide") {
      tagList(
        textInput("regLocation", "Location"),
        textInput("regExpertise", "Expertise"),
        numericInput("regPrice", "Price", value = 100, min = 0),
      )
    } 
  })
  
  #### User login ####
  observeEvent(input$login, {
    req(input$email, input$password)  # Ensure both email and password are provided
    hashed_password <- digest(input$password, algo = "sha256")
    user_info<-""
    # Look for the user in the credentials dataset
    user <- credentials %>% filter(email == input$email & password == hashed_password)
    currentUser(user)
    role(user$role)
    
    if (nrow(user) == 1) {  # If a user match is found
      if (role() == "Guide") {
        
        user_info <- guides %>% filter(email == user$email)
      } else if (role() == "Tourist") {
        user_info <- users %>% filter(email == user$email)
      }
      
      if (nrow(user_info) == 1) {
        currentUser(list(
          name = user_info$name,
          email = user$email,
          role = role(),
          location = if ("location" %in% colnames(user_info)) as.character(user_info$location) else NA,
          expertise = if ("expertise" %in% colnames(user_info)) as.character(user_info$expertise) else NA,
          price = if ("price" %in% colnames(user_info)) user_info$price else NA,
          language = if ("language" %in% colnames(user_info)) as.character(user_info$language) else NA
        ))
       
        userLoggedIn(TRUE)
        updateF7Tabs(session, id = "tabs", selected = "Profile")
        # Update the UI with the current user's data
        if (!is.na(currentUser()$location) && currentUser()$location != "") {
          updatePickerInput(session, "editLocation", selected = unlist(strsplit(currentUser()$location, ",")))
        }
        
        if (!is.na(currentUser()$expertise) && currentUser()$expertise != "") {
          updateTextInput(session, "editExpertise", value = currentUser()$expertise)
        }
        
        if (!is.na(currentUser()$price)) {
          updateNumericInput(session, "editPrice", value = currentUser()$price)
        }
        
        if (!is.na(currentUser()$language) && currentUser()$language != "") {
          updatePickerInput(session, "editLanguages", selected = unlist(strsplit(currentUser()$language, ",")))
        }
        
        updateTextInput(session, "editName", value = currentUser()$name)
        updateTextInput(session, "editEmail", value = currentUser()$email)
      } else {
        showNotification("User information could not be found.", type = "error", duration = 5)
      }
    } else {
      showNotification("Invalid email or password. Please try again.", type = "error", duration = 5)
    }
  })
  
  #### User logout ####
  observeEvent(input$logout, {
    showNotification("Logged out successfully.", type = "message", duration = 2)
    
    session$reload()
  })
  #### Render search and sorted results ####
  output$searchResults <- renderDT({
    # Determine if the user is a Guide or Tourist
    user_is_tourist <- userLoggedIn() && !is.null(currentUser()) && currentUser()$role != "Guide"
    
    searchResultsTable <- searchResults() %>%
      select(-email) %>%
      mutate(
        Appointment = if (user_is_tourist) {
          paste0('<button id="request_', row_number(), '" class="btn btn-primary full-width">Request</button>')
        } else {
          NA  # Set as NA for guides
        }
      )
    
    # Remove the Appointment column entirely if the user is a Guide
    if (!user_is_tourist) {
      searchResultsTable <- searchResultsTable %>% select(-Appointment)
    }
    
    datatable(
      searchResultsTable,
      options = list(
        pageLength = 10, 
        autoWidth = TRUE,
        responsive = TRUE
      ),
      rownames = FALSE,
      escape = FALSE,
      selection = "none",
      callback = JS(
        "table.on('click', '.btn-primary', function() {",
        "  var data = table.row($(this).parents('tr')).data();",
        "  Shiny.setInputValue('select_guide', data[0], {priority: 'event'});",
        "});"
      )
    )
  })
  
  
  
  
  observe({
    selected_guide <- input$select_guide
    if (!is.null(selected_guide)) {
      shinyjs::runjs("$('#tabs a[href=\"#Appointment\"]').click();")  
      shinyjs::runjs("setTimeout(function() { $('#appointmentDate').click(); }, 500);")
    }
  })
  
  #### Trigger Date Picker Automatically ####
  observeEvent(input$requestAppointment, {
    req(userLoggedIn())
    
    selectedGuide("John Doe")
    
    updateF7Tabs(session, id = "tabs", selected = "Appointment")
    
    # Automatically open the date picker after the tab is selected
    runjs("document.getElementById('appointmentDate').focus();")
  })
  
  
  
  #### Select guide and request appointment ####
  observeEvent(input$select_guide, {
    req(userLoggedIn())  
    
    selectedGuide(input$select_guide)
    
    insertF7Tab(
      id = "tabs",
      tab = f7Tab(
        tabName = "Appointment",
        icon = f7Icon("calendar"),
        active = FALSE,
        f7Card(
          h4("Request Appointment with John Doe"),
          div(style = "margin-bottom: 10px; font-weight: bold; color: #007aff;", 
              "Please select a date from the calendar below."),
          f7DatePicker(
            inputId = "appointmentDate",
            label = "Click Here to Select Date",
            value = Sys.Date(),
            min = Sys.Date(), 
            openIn = "sheet",
            dateFormat = "yyyy-mm-dd"
          ),
          textInput("appointmentTime", "Select Time (e.g., 10:00)", value = "10:00"),
          f7Button(inputId = "confirmAppointment", label = "Request", color = "blue")
        )
      )
    )
    
    updateF7Tabs(session, id = "tabs", selected = "Appointment")
  })
  
  #### Confirm the appointment ####
  observeEvent(input$confirmAppointment, {
    req(selectedGuide(), currentUser())
    
    selected_date <- input$appointmentDate
    selected_time <- input$appointmentTime
    
    # Show a notification with the selected appointment details
    showNotification(paste("Appointment requested for", selected_date, "at", selected_time), type = "message")
    
    removeF7Tab(id = "tabs", target = "Appointment", session = session)
    updateF7Tabs(session, id = "tabs", selected = "Profile")
  })
  
  
  
  
  
  #### Guide-Requests ####
  observe({
    req(currentUser(), currentUser()$role == "Guide")
    
    output$guideRequests <- renderDT({
      guide_requests <- pending_requests() %>% filter(guide == currentUser()$name)
      
      guide_requests <- guide_requests %>%
        mutate(Actions = paste0(
          '<button class="btn-accept" style="padding: 6px 12px; margin-right: 5px; width: 100px;" data-row="', row_number(), '">Accept</button>',
          '<button class="btn-reject" style="padding: 6px 12px; width: 100px;" data-row="', row_number(), '">Reject</button>'
        ))
      
      datatable(
        guide_requests,
        options = list(
          pageLength = 5,
          autoWidth = TRUE,
          columnDefs = list(list(targets = -1, className = 'dt-center'))
        ),
        rownames = FALSE,
        escape = FALSE,
        selection = "none",
        callback = JS(
          "table.on('click', '.btn-accept', function() {",
          "  var row = $(this).data('row');",
          "  Shiny.setInputValue('accept_request_row', row, {priority: 'event'});",
          "});",
          "table.on('click', '.btn-reject', function() {",
          "  var row = $(this).data('row');",
          "  Shiny.setInputValue('reject_request_row', row, {priority: 'event'});",
          "});"
        )
      )
    })
  })
    
    observeEvent(input$guideRequests_rows_selected, {
      selected_row <- input$guideRequests_rows_selected
      if (length(selected_row)) {
        selected_request <- pending_requests()[selected_row, ]
        
        showModal(
          modalDialog(
            title = "Appointment Request",
            h4(paste("Request from", selected_request$user)),
            textInput("responseMessage", "Response Message"),
            div(
              style = "display: flex; justify-content: space-between;",
              actionButton("acceptRequest", "Accept", class = "btn btn-success"),
              actionButton("rejectRequest", "Reject", class = "btn btn-danger")
            ),
            footer = modalButton("Close")
          )
        )
      }
    })
  
  
  
  ####Reques accepted####
  observeEvent(input$accept_request_row, {
    req(currentUser(), currentUser()$role == "Guide")
    
    row <- as.numeric(input$accept_request_row)
    pending_data <- isolate(pending_requests())
    
    guide_requests <- pending_data %>%
      filter(guide == currentUser()$email)
    
    if (!is.null(guide_requests) && nrow(guide_requests) > 0 && row > 0 && row <= nrow(guide_requests)) {
      actual_row <- guide_requests[row, ]
      
      row_index <- which(
        pending_data$user == actual_row$user & 
          pending_data$guide == actual_row$guide & 
          pending_data$date == actual_row$date & 
          pending_data$time == actual_row$time
      )
      
      if (length(row_index) == 1) {
        pending_data[row_index, "status"] <- "Accepted"
        pending_data[row_index, "message"] <- "Request accepted."
        
        pending_requests(pending_data)
        saveRDS(pending_requests(), "pending_requests.rds")
        
        output$profileRequests <- renderDT({
          createProfileRequestsTable(pending_requests(), currentUser())
        })
        
        showNotification("Request accepted.", type = "message", duration = 5)
      } else {
        showNotification("Failed to find the correct request to accept.", type = "error", duration = 5)
      }
    } else {
      showNotification("Invalid row selected or no matching guide requests found.", type = "error", duration = 5)
    }
  })
  
  observeEvent(input$reject_request_row, {
    req(currentUser(), currentUser()$role == "Guide")
    
    row <- as.numeric(input$reject_request_row)
    pending_data <- isolate(pending_requests())
    
    if (!is.null(pending_data) && row > 0 && row <= nrow(pending_data)) {
      
      guide_requests <- pending_data %>% filter(guide == currentUser()$email)
      actual_row <- guide_requests[row, ]
      
      row_index <- which(
        pending_data$user == actual_row$user & 
          pending_data$guide == actual_row$guide & 
          pending_data$date == actual_row$date & 
          pending_data$time == actual_row$time
      )
      
      if (length(row_index) == 1) {
        pending_data[row_index, "status"] <- "Rejected"
        pending_data[row_index, "message"] <- "Request rejected."
        
        pending_requests(pending_data)
        saveRDS(pending_requests(), "pending_requests.rds")
        output$profileRequests <- renderDT({
          createProfileRequestsTable(pending_requests(), currentUser())
        })
        
        showNotification("Request rejected.", type = "message", duration = 5)
      } else {
        showNotification("Failed to find the correct request to reject.", type = "error", duration = 5)
      }
    } else {
      showNotification("Invalid row selected for request rejection.", type = "error", duration = 5)
    }
  })
  
  
  #### Save profile changes ####
  observeEvent(input$saveProfile, {
    req(currentUser())  # Ensure there is a logged-in user
    
    user_email <- currentUser()$email
    
    if (currentUser()$role == "Guide") {
      
      guides <<- guides %>%
        filter(email != user_email) %>%
        bind_rows(data.frame(
          name = input$editName,
          email = user_email,
          location = paste(input$editLocation, collapse = ","),
          expertise = paste(input$editExpertise, collapse = ","),
          price = input$editPrice,
          language = paste(input$editLanguages, collapse = ","),
          rating = guides$rating[guides$email == user_email],
          stringsAsFactors = FALSE
        ))
      
      saveRDS(guides, "guides.rds")
      
      # Reset inputs after saving to the saved values
      updatePickerInput(session, "editLocation", selected = unlist(strsplit(paste(input$editLocation, collapse = ","), ",")))
      updatePickerInput(session, "editExpertise", selected = unlist(strsplit(paste(input$editExpertise, collapse = ","), ",")))
      updateNumericInput(session, "editPrice", value = input$editPrice)
      updatePickerInput(session, "editLanguages", selected = unlist(strsplit(paste(input$editLanguages, collapse = ","), ",")))
      
    } else if (currentUser()$role == "Tourist") {
      
      users <<- users %>%
        filter(email != user_email) %>%
        bind_rows(data.frame(
          name = input$editName,
          email = user_email,
          language = paste(input$editLanguages, collapse = ","),
          stringsAsFactors = FALSE
        ))
      
      saveRDS(users, "users.rds")
      
      # Reset inputs after saving to the saved values
      updatePickerInput(session, "editLanguages", selected = unlist(strsplit(paste(input$editLanguages, collapse = ","), ",")))
    }
    
    updateF7Tabs(session, id = "tabs", selected = "Profile")
    showNotification("Profile updated successfully.", type = "message", duration = 5)
  })
  
  
  
  #### Update the dynamic profile fields based on the user role ####
  output$dynamicProfileFields <- renderUI({
    req(currentUser())
    
    if (role() == "Guide") {
      
      guide_info <- guides %>% filter(email == currentUser()$email)
      
      if (nrow(guide_info) == 1) {
        tagList(
          # Location field with multiple selection
          div(class = "form-row",
              tags$label("Location", class = "form-label"),
              div(class = "form-input",
                  pickerInput("editLocation", "", 
                              choices = c("New York", "Los Angeles", "Berlin", "Paris", "Tokyo", "Sydney"), 
                              multiple = TRUE, 
                              selected = if (!is.na(guide_info$location) && is.character(guide_info$location)) unlist(strsplit(guide_info$location, ",")) else NULL,
                              options = list(`live-search` = FALSE))
              )
          ),
          
          div(class = "form-row",
              tags$label("Expertise", class = "form-label"),
              div(class = "form-input",
                  pickerInput("editExpertise", "", 
                              choices = c("History", "Art", "Culinary", "Nature", "Adventure", "Culture"), 
                              multiple = TRUE, 
                              selected = if (!is.na(guide_info$expertise) && is.character(guide_info$expertise)) unlist(strsplit(guide_info$expertise, ",")) else NULL,
                              options = list(`live-search` = FALSE))
              )
          ),
          
          div(class = "form-row",
              tags$label("Price", class = "form-label"),
              div(class = "form-input",
                  numericInput("editPrice", "", value = if (!is.na(guide_info$price)) guide_info$price else 0, min = 0, step = 10)
              )
          ),
          
          div(class = "form-row",
              tags$label("Languages", class = "form-label"),
              div(class = "form-input",
                  pickerInput("editLanguages", "", 
                              choices = c("English", "German", "Spanish", "French", "Chinese", "Russian", "Japanese", "Arabic", "Italian", "Portuguese", "Other"), 
                              multiple = TRUE, 
                              selected = if (!is.na(guide_info$language) && is.character(guide_info$language)) unlist(strsplit(guide_info$language, ",")) else NULL,
                              options = list(`live-search` = FALSE))
              )
          )
        )
      } else {
        # Handle case where the guide info is not found
        showNotification("Guide information could not be found.", type = "error", duration = 5)
      }
      
    } else if (role() == "Tourist") {
      users <- readRDS("users.rds")  # Load the latest users data
      user_info <- users %>% filter(email == currentUser()$email)
      
      if (nrow(user_info) == 1) {
        tagList(
          # Languages field with multiple selection
          div(class = "form-row",
              tags$label("Languages", class = "form-label"),
              div(class = "form-input",
                  pickerInput("editLanguages", "", 
                              choices = c("English", "German", "Spanish", "French", "Chinese", "Russian", "Japanese", "Arabic", "Italian", "Portuguese", "Other"), 
                              multiple = TRUE, 
                              selected = if (!is.na(user_info$language) && is.character(user_info$language)) unlist(strsplit(user_info$language, ",")) else NULL,
                              options = list(`live-search` = FALSE))
              )
          )
        )
      } else {
        # Handle case where the user info is not found
        showNotification("User information could not be found.", type = "error", duration = 5)
      }
    }
  })
  
  
  # Render the DataTable
  output$profileRequests <- renderDT({
    req(currentUser())  # Ensure the user is logged in
    createProfileRequestsTable(pending_requests(), currentUser())
  })
  
  output$requestButtonUI <- renderUI({
    user <- currentUser()  
    
    if (!is.null(user) && !is.null(user$role) && length(user$role) > 0 && user$role != "Guide") {
      f7Button(inputId = "requestAppointment", label = "Request Appointment", color = "blue")
    } else {
      return(NULL)  
    }
  })
  
  
  createProfileRequestsTable <- function(pending_data, current_user) {
    req(current_user) 
    
    if (is.null(pending_data) || nrow(pending_data) == 0) {
      return(NULL) 
    }
    
    if (!is.null(current_user$role) && current_user$role == "Guide") {
      pending_data <- pending_data %>%
        left_join(guides, by = c("guide" = "email")) %>%
        left_join(users, by = c("user" = "email")) %>%
        select(user = name.y, guide = name.x, date, time, status)
      
      user_requests <- pending_data %>%
        filter(guide == current_user$name)
      
      if (nrow(user_requests) == 0) {
        return(NULL) 
      }
      user_requests <- user_requests %>%
        mutate(
          Actions = ifelse(
            status == "Pending",
            paste0('<button class="btn-accept" data-row="', row_number(), '">Accept</button> ',
                   '<button class="btn-reject" data-row="', row_number(), '">Reject</button>'),
            ""
          )
        )
      # Remove 'Actions' column for guides
      return(
        datatable(
          user_requests,
          options = list(
            pageLength = 5,
            autoWidth = TRUE,
            responsive = TRUE
          ),
          rownames = FALSE,
          escape = FALSE,
          selection = "none"
        )
      )
      
    } else {
      # Replace emails with names
      pending_data <- pending_data %>%
        left_join(guides, by = c("guide" = "email")) %>%
        left_join(users, by = c("user" = "email")) %>%
        select(user = name.y, guide = name.x, date, time, status)
      
      tourist_requests <- pending_data %>% filter(user == current_user$name)
      
      if (nrow(tourist_requests) == 0) {
        return(NULL)  
      }
      
      return(
        datatable(
          tourist_requests,
          options = list(pageLength = 5, autoWidth = TRUE),
          rownames = FALSE
        )
      )
    }
  }
  
  
  #### Load existing data into Edit Profile fields on tab load ####
  observe({
    req(userLoggedIn(), currentUser())  
    
    updateTextInput(session, "editName", value = currentUser()$name)
    updateTextInput(session, "editEmail", value = currentUser()$email)
    
    if (currentUser()$role == "Guide") {
      guides <- readRDS("guides.rds")  # Load the latest guides data
      guide_info <- guides %>% filter(email == currentUser()$email)
      
      if (nrow(guide_info) == 1) {
        
        updatePickerInput(session, "editLocation", selected = unlist(strsplit(guide_info$location, ",")))
        updateTextInput(session, "editExpertise", value = guide_info$expertise)
        updateNumericInput(session, "editPrice", value = guide_info$price)
        updatePickerInput(session, "editLanguages", selected = unlist(strsplit(guide_info$language, ",")))
        
      } else {
        
        showNotification("Guide information could not be found.", type = "error", duration = 5)
      }
    } else if (currentUser()$role == "Tourist") {
      users <- readRDS("users.rds")  # Load the latest users data
      user_info <- users %>% filter(email == currentUser()$email)
      
      if (nrow(user_info) == 1) {
        updatePickerInput(session, "editLanguages", selected = unlist(strsplit(user_info$language, ",")))
      } else {
        showNotification("User information could not be found.", type = "error", duration = 5)
      }
    }
  })
}

# Run the app
shinyApp(ui = ui, server = server)