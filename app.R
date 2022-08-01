library(dplyr)
library(rvest)
library(stringr)
library(data.table)
library(formattable)
library(shiny)
library(shinycssloaders)
library(shinythemes)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  theme = shinytheme("darkly"),
  
  titlePanel("World of Warcraft Arena/RBG Tracker"),
  
  sidebarPanel(
    selectInput("variable", "Select Bracket",
                c("2v2" = "2v2",
                  "3v3" = "3v3",
                  "Rated BGs" = "battlegrounds")),
    strong("About:"),
    br(),
    ("This app simply displays the top 1000 2v2, 3v3 and rated battlegrounds players depending on
     which bracket you select using the drop down menu!"),
    br(),
    br(),
    
    strong("How it Works:"),
    br(),
    ("This app scrapes data directly from the World of Warcraft website allowing for an accurate representation of the top 1000 players.
     The data is updated once each day!")
    ),
  
  mainPanel(
    
    tabsetPanel(type = "tabs",
                tabPanel("Overview",
                         plotOutput("plot") %>% withSpinner(color="#0dc5c1"),
                         br(),
                         plotOutput("piechart") %>% withSpinner()
                ),
                tabPanel("Class Talents",
                         selectInput("class","Select Class",
                                     c("Death Knight" = "Death Knight",
                                       "Demon Hunter" = "Demon Hunter",
                                       "Druid" = "Druid",
                                       "Hunter" = "Hunter",
                                       "Mage" = "Mage",
                                       "Monk" = "Monk",
                                       "Paladin" = "Paladin",
                                       "Priest" = "Priest",
                                       "Rogue" = "Rogue",
                                       "Shaman" = "Shaman",
                                       "Warlock" = "Warlock",
                                       "Warrior" = "Warrior")),
                         plotOutput("plot1") %>% withSpinner(),
                         br(),
                         plotOutput("plot2") %>% withSpinner(),
                         br(),
                         plotOutput("plot3") %>% withSpinner(),
                         br(),
                         plotOutput("plot4") %>% withSpinner()
                         
                ),
                tabPanel("PvP Talents",
                         selectInput("pvpClass","Select Class",
                                     c("Death Knight" = "Death Knight",
                                       "Demon Hunter" = "Demon Hunter",
                                       "Druid" = "Druid",
                                       "Hunter" = "Hunter",
                                       "Mage" = "Mage",
                                       "Monk" = "Monk",
                                       "Paladin" = "Paladin",
                                       "Priest" = "Priest",
                                       "Rogue" = "Rogue",
                                       "Shaman" = "Shaman",
                                       "Warlock" = "Warlock",
                                       "Warrior" = "Warrior")),
                         plotOutput("pvpTalents1") %>% withSpinner(),
                         plotOutput("pvpTalents2") %>% withSpinner(),
                         plotOutput("pvpTalents3") %>% withSpinner(),
                         plotOutput("pvpTalents4") %>% withSpinner()
                         
                  
                  
                )
                )
  )
  
  
  
  
  
  
    )

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  
  current_environment = environment()
  
  MakeTalentsPlots = function(){
    
    plot1 = NULL
    plot2 = NULL
    plot3 = NULL
    plot4 = NULL
    
    pvpTalents1 = NULL
    pvpTalents2 = NULL
    pvpTalents3 = NULL
    pvpTalents4 = NULL
    
    assign("plot1",plot1,.GlobalEnv)
    assign("plot2",plot2,.GlobalEnv)
    assign("plot3",plot3,.GlobalEnv)
    assign("plot4",plot4,.GlobalEnv)
    assign("pvpTalents1",pvpTalents1,.GlobalEnv)
    assign("pvpTalents2",pvpTalents2,.GlobalEnv)
    assign("pvpTalents3",pvpTalents3,.GlobalEnv)
    assign("pvpTalents4",pvpTalents4,.GlobalEnv)
    
    
    
    bracket = input$variable
    
    if(bracket == "2v2"){
      uniq = read.csv("uniq_2v2.csv")
      important_df = read.csv("talents_df_2v2.csv")
      pie_df = read.csv("pie_df_2v2.csv")
      pvp_talents_df = read.csv("pvp_talents_df_2v2.csv")
    }else if(bracket == "3v3"){
      uniq = read.csv("uniq_3v3.csv")
      important_df = read.csv("talents_df_3v3.csv")
      pie_df = read.csv("pie_df_3v3.csv")
      pvp_talents_df = read.csv("pvp_talents_df_3v3.csv")
    }else if(bracket == "battlegrounds"){
      uniq = read.csv("uniq_rbg.csv")
      important_df = read.csv("talents_df_rbg.csv")
      pie_df = read.csv("pie_df_rbg.csv")
      pvp_talents_df = read.csv("pvp_talents_df_rbg.csv")
    }
    
    specific_class = input$class
    specific_class_pvp = input$pvpClass
    print(specific_class)
    important_df = filter(important_df, Class == specific_class)
    pvp_talents_df = filter(pvp_talents_df, Class == specific_class_pvp)
   
    assign("important_df",important_df, .GlobalEnv)
    assign("pvp_talents_df",pvp_talents_df,.GlobalEnv)
    indi_specs = unique(important_df$Spec)
    indi_pvp_specs = unique(pvp_talents_df$Spec)
    print(indi_specs)
    for(i in 1:length(indi_specs)){
      indi_df = filter(important_df, Spec == indi_specs[i])
      indi_df$Talent = as.factor(indi_df$Talent)
      maxcount = as.integer(sort(summary(indi_df$Talent), decreasing = TRUE)[1] + 50)
      
      plot = ggplot(indi_df, aes(x = Talent.Level, fill = Talent)) + geom_bar(stat = "count",position = "dodge", alpha = 0.5) +
        geom_text(stat = "count", aes(label = Talent, angle = "90"), position = position_dodge(width = 5), vjust = 0.4, hjust = -0.2, size = 3.5) +
        ylim(0,maxcount) +
        xlab("Talent Level") +
        ylab("Count") +
        ggtitle(label = paste0(indi_df$Spec[1]," ",indi_df$Class[1]," Talents ",bracket)) +
        theme(legend.position = "none")
      assign(paste0("plot",i),plot,.GlobalEnv)
    }
    
    for(i in 1:length(indi_pvp_specs)){
      
      indi_pvp_df = filter(pvp_talents_df, Spec == indi_pvp_specs[i])
      
      pvp_talents_plot = ggplot(indi_pvp_df, aes(x = PvP.Talent, fill = PvP.Talent)) + geom_bar(stat = "count", alpha = 0.5) +
        ggtitle(label = paste0(indi_pvp_df$Spec[1]," ",indi_pvp_df$Class[1]," Talents ",bracket)) +
        theme(legend.position = "none", axis.text.x = element_text(angle = 90))
      assign(paste0("pvpTalents",i),pvp_talents_plot, .GlobalEnv)
    }
    
    
    
  }
  
  
  observeEvent(input$variable, {
    output$plot = NULL
    #### Retrieve which bracket was selected
    print(input$variable)
    
    bracket = input$variable
    
    if(bracket == "2v2"){
      uniq = read.csv("uniq_2v2.csv")
      #important_df = read.csv("important_df_2v2.csv")
      pie_df = read.csv("pie_df_2v2.csv")
    }else if(bracket == "3v3"){
      uniq = read.csv("uniq_3v3.csv")
      pie_df = read.csv("pie_df_3v3.csv")
      #important_df = read.csv("important_df_3v3.csv")
    }else if(bracket == "battlegrounds"){
      uniq = read.csv("uniq_rbg.csv")
      pie_df = read.csv("pie_df_rbg.csv")
      #important_df = read.csv("important_df_battlegrounds.csv")
    }
    
    assign("uniq",uniq,.GlobalEnv)
    # assign("important_df",important_df,.GlobalEnv)
    
    
    
    current_date = Sys.time()
    current_date = str_match(current_date, ".{10}")[1]
    
    
    spec_vec = uniq$spec
    classes_vec = uniq$class
    
    spec_class_vec = paste(spec_vec,classes_vec, sep = " ")
    spec_class_vec = str_replace(spec_class_vec," ",".")
    spec_class_vec = str_replace(spec_class_vec,"Havoc.Hunter", "Havoc.Demon.Hunter")
    spec_class_vec = str_replace(spec_class_vec,"Vengeance.Hunter", "Vengeance.Demon.Hunter")
    spec_class_vec = str_replace(spec_class_vec,"Beast.Mastery Hunter", "Beast.Mastery.Hunter")
    spec_class_vec = str_replace(spec_class_vec,"Unholy.Death Knight", "Unholy.Death.Knight")
    
    
    theme_set(theme_gray())
    
    
    tbl_class = as.data.frame(table(classes_vec))
    tbl_spec = as.data.frame(table(spec_vec))
    
    #Create table for piechart
    # pie_df = data.table(Faction = c("Horde","Alliance"),
    #                     Count = c(num_hor, num_ali))
    
    dasplot = ggplot(uniq, aes (x = class, y = Freq, fill = spec)) + 
      geom_bar(stat="identity", position = "dodge", alpha = 0.5) +
      geom_text(aes(label = spec, angle = "90"), position = position_dodge(width = 1), vjust = 0.4, hjust = -0.2, size = 3.5) +
      theme(legend.position = "none") +
      ggtitle(label = paste0("Class and Spec of top 1000 ",input$variable," Players"), subtitle = current_date) +
      xlab(label = "Class") +
      ylab(label = "Count") +
      ylim(0,max(uniq$Freq + 30)) +
      theme(axis.text.x = element_text(angle = 90, size = 11))
    
    piechart = ggplot(pie_df, aes(x = "", y = Freq, fill = factions)) + geom_bar(stat = "identity") +
      coord_polar("y", start = 0) +
      ggtitle(label = paste0("Horde and Alliance population comparison for the ", input$variable, " bracket")) +
      scale_fill_manual(values = c("blue1","red1"))

    
    MakeTalentsPlots()
    
    output$plot = renderPlot(dasplot)
    output$piechart = renderPlot(piechart)
    if(!is.null(plot1)){
      output$plot1 = renderPlot(plot1)  
    }
    if(!is.null(plot2)){
      output$plot2 = renderPlot(plot2)  
    }
    else{
      output$plot2 = NULL
    }
    if(!is.null(plot3)){
      output$plot3 = renderPlot(plot3)  
    }else{
      output$plot3 = NULL
    }
    if(!is.null(plot4)){
      output$plot4 = renderPlot(plot4)  
    }else{
      output$plot4 = NULL
    }
    if(!is.null(pvpTalents1)){
      output$pvpTalents1 = renderPlot(pvpTalents1)  
    }else{
      output$pvpTalents1 = NULL
    }
    if(!is.null(pvpTalents2)){
      output$pvpTalents2 = renderPlot(pvpTalents2)  
    }else{
      output$pvpTalents2 = NULL
    }
    if(!is.null(pvpTalents3)){
      output$pvpTalents3 = renderPlot(pvpTalents3)  
    }else{
      output$pvpTalents3 = NULL
    }
    if(!is.null(pvpTalents4)){
      output$pvpTalents4 = renderPlot(pvpTalents4)  
    }else{
      output$pvpTalents4 = NULL
    }
    
  })
  
  ##############################################Now to check for talents#############################################
  observeEvent(input$class,{
    
    MakeTalentsPlots()
    
    if(!is.null(plot1)){
      output$plot1 = renderPlot(plot1)  
    }
    if(!is.null(plot2)){
      output$plot2 = renderPlot(plot2)  
    }
    else{
      output$plot2 = NULL
    }
    if(!is.null(plot3)){
      output$plot3 = renderPlot(plot3)  
    }else{
      output$plot3 = NULL
    }
    if(!is.null(plot4)){
      output$plot4 = renderPlot(plot4)  
    }else{
      output$plot4 = NULL
    }
    
    
  })
  
  observeEvent(input$pvpClass, {
    MakeTalentsPlots()
    
    if(!is.null(pvpTalents1)){
      output$pvpTalents1 = renderPlot(pvpTalents1)  
    }else{
      output$pvpTalents1 = NULL
    }
    if(!is.null(pvpTalents2)){
      output$pvpTalents2 = renderPlot(pvpTalents2)  
    }else{
      output$pvpTalents2 = NULL
    }
    if(!is.null(pvpTalents3)){
      output$pvpTalents3 = renderPlot(pvpTalents3)  
    }else{
      output$pvpTalents3 = NULL
    }
    if(!is.null(pvpTalents4)){
      output$pvpTalents4 = renderPlot(pvpTalents4)  
    }else{
      output$pvpTalents4 = NULL
    }
    
  })
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

