ibrary(dplyr)
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
                         
                ))
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
    
    assign("plot1",plot1,.GlobalEnv)
    assign("plot2",plot2,.GlobalEnv)
    assign("plot3",plot3,.GlobalEnv)
    assign("plot4",plot4,.GlobalEnv)
    
    
    bracket = input$variable
    
    if(bracket == "2v2"){
      uniq = read.csv("uniq_2v2.csv")
      important_df = read.csv("talents_df_2v2.csv")
      pie_df = read.csv("pie_df_2v2.csv")
    }else if(bracket == "3v3"){
      uniq = read.csv("uniq_3v3.csv")
      important_df = read.csv("talents_df_3v3.csv")
      pie_df = read.csv("pie_df_3v3.csv")
    }else if(bracket == "battlegrounds"){
      uniq = read.csv("uniq_rbg.csv")
      important_df = read.csv("talents_df_rbg.csv")
      pie_df = read.csv("pie_df_rbg.csv")
    }
    
    specific_class = input$class
    # specific_class = gsub(" ","",specific_class)
    print(specific_class)
    important_df = filter(important_df, Class == specific_class)
    
    
    #important_df$Talent.Level = rep(c(15,25,30,35,40,45,50), times = nrow(important_df)/7)
    
    # if(nrow(important_df > 0)){
    #   for(i in 1:nrow(important_df)){
    #     if(any(grepl(important_df$Talent[i], specific_talents_df[1:3,]))){
    #       important_df$Talent.Level[i] = 15
    #     }
    #     if(any(grepl(important_df$Talent[i], specific_talents_df[4:6,]))){
    #       important_df$Talent.Level[i] = 25
    #     }
    #     if(any(grepl(important_df$Talent[i], specific_talents_df[7:9,]))){
    #       important_df$Talent.Level[i] = 30
    #     }
    #     if(any(grepl(important_df$Talent[i], specific_talents_df[10:12,]))){
    #       important_df$Talent.Level[i] = 35
    #     }
    #     if(any(grepl(important_df$Talent[i], specific_talents_df[13:15,]))){
    #       important_df$Talent.Level[i] = 40
    #     }
    #     if(any(grepl(important_df$Talent[i], specific_talents_df[16:18,]))){
    #       important_df$Talent.Level[i] = 45
    #     }
    #     if(any(grepl(important_df$Talent[i], specific_talents_df[19:21,]))){
    #       important_df$Talent.Level[i] = 50
    #     }
    #   }
    # }
    assign("important_df",important_df, .GlobalEnv)
    indi_specs = unique(important_df$Spec)
    print(indi_specs)
    for(i in 1:length(indi_specs)){
      indi_df = filter(important_df, Spec == indi_specs[i])
      indi_df$Talent = as.factor(indi_df$Talent)
      maxcount = as.integer(sort(summary(indi_df$Talent), decreasing = TRUE)[1] + 10)
      
      plot = ggplot(indi_df, aes(x = Talent.Level, fill = Talent)) + geom_bar(stat = "count",position = "dodge", alpha = 0.5) +
        geom_text(stat = "count", aes(label = Talent, angle = "90"), position = position_dodge(width = 5), vjust = 0.4, hjust = -0.2, size = 3.5) +
        ylim(0,maxcount) +
        xlab("Talent Level") +
        ylab("Count") +
        ggtitle(label = paste0(indi_df$Spec[1]," ",indi_df$Class[1]," Talents ",bracket)) +
        theme(legend.position = "none")
      assign(paste0("plot",i),plot,.GlobalEnv)
    }
  }
  
  # Extract a list of all of the talents in the game
  # talent_extract = read_html("https://worldofwarcraft.com/en-us/game/talent-calculator#death-knight/blood") %>%
  #   html_nodes(".Talent")
  # talent_extract = html_text(talent_extract)
  # test_text_extract = str_extract(talent_extract, "(.*?)\\(")
  # test_text_extract = str_replace(test_text_extract, "\\(", "")
  # test_text_extract = test_text_extract[-1]
  # test_text_extract = test_text_extract[!is.na(test_text_extract)]
  
  ## Need to create a data.frame of all classes with their specs/talents
  
  # Blood_DeathKnight_Talents = c(test_text_extract[1:21])
  # Frost_DeathKnight_Talents = c(test_text_extract[22:42])
  # Unholy_DeathKnight_Talents = c(test_text_extract[43:63])
  # 
  # Havoc_DemonHunter_Talents = c(test_text_extract[64:84])
  # Vengeance_DemonHunter_Talents = c(test_text_extract[85:105])
  # 
  # Balance_Druid_Talents = c(test_text_extract[106:126])
  # Feral_Druid_Talents = c(test_text_extract[127:147])
  # Guardian_Druid_Talents = c(test_text_extract[148:168])
  # Restoration_Druid_Talents = c(test_text_extract[169:189])
  # 
  # BeastMastery_Hunter_Talents = c(test_text_extract[190:210])
  # Marksman_Hunter_Talents = c(test_text_extract[211:231])
  # Survival_Hunter_Talents = c(test_text_extract[232:252])
  # 
  # Arcane_Mage_Talents = c(test_text_extract[253:273])
  # Fire_Mage_Talents = c(test_text_extract[274:294])
  # Frost_Mage_Talents = c(test_text_extract[295:315])
  # 
  # Brewmaster_Monk_Talents = c(test_text_extract[316:336])
  # Mistweaver_Monk_Talents = c(test_text_extract[337:357])
  # Windwalker_Monk_Talents = c(test_text_extract[358:378])
  # 
  # Holy_Paladin_Talents = c(test_text_extract[379:399])
  # Protection_Paladin_Talents= c(test_text_extract[400:420])
  # Retribution_Paladin_Talents = c(test_text_extract[421:441])
  # 
  # Discipline_Priest_Talents = c(test_text_extract[442:462])
  # Holy_Priest_Talents = c(test_text_extract[463:483])
  # Shadow_Priest_Talents = c(test_text_extract[484:504])
  # 
  # Assassination_Rogue_Talents = c(test_text_extract[505:525])
  # Outlaw_Rogue_Talents = c(test_text_extract[526:546])
  # Subtlety_Rogue_Talents = c(test_text_extract[547:567])
  # 
  # Elemental_Shaman_Talents = c(test_text_extract[568:588])
  # Enhancement_Shaman_Talents = c(test_text_extract[589:609])
  # Restoration_Shaman_Talents = c(test_text_extract[610:630])
  # 
  # Affliction_Warlock_Talents = c(test_text_extract[631:651])
  # Demonology_Warlock_Talents = c(test_text_extract[652:672])
  # Destruction_Warlock_Talents = c(test_text_extract[673:693])
  # 
  # Arms_Warrior_Talents = c(test_text_extract[694:714])
  # Fury_Warrior_Talents = c(test_text_extract[715:735])
  # Protection_Warrior_Talents = c(test_text_extract[736:756])
  
  
  specs_df = data.frame("DeathKnight" = c("Blood","Frost","Unholy","Blood",NA),
                        "DemonHunter" = c("Havoc","Vengeance","Havoc",NA,NA),
                        "Druid" = c("Balance", "Feral", "Guardian","Restoration", "Balance"),
                        "Hunter" = c("Beast Mastery", "Marksmanship", "Survival", "Beast Mastery",NA),
                        "Mage" = c("Arcane","Fire","Frost","Arcane",NA),
                        "Monk" = c("Brewmaster","Windwalker","Mistweaver","Brewmaster",NA),
                        "Paladin" = c("Holy","Protection","Retribution","Holy",NA),
                        "Priest" = c("Discipline","Holy","Shadow","Discipline",NA),
                        "Rogue" = c("Assassination","Outlaw","Subtlety","Assassination",NA),
                        "Shaman" = c("Elemental","Enhancement","Restoration","Elemental",NA),
                        "Warlock" = c("Affliction","Demonology","Destruction","Affliction",NA),
                        "Warrior" = c("Arms","Fury","Protection","Arms",NA)
  )
  
  # 
  # talents_df = data.frame("Survival Hunter" = Survival_Hunter_Talents,
  #                         "Marksmanship Hunter" = Marksman_Hunter_Talents,
  #                         "Beast Mastery Hunter" = BeastMastery_Hunter_Talents,
  #                         "Blood Death Knight" = Blood_DeathKnight_Talents,
  #                         "Frost Death Knight" = Frost_DeathKnight_Talents,
  #                         "Unholy Death Knight" = Unholy_DeathKnight_Talents,
  #                         "Havoc Demon Hunter" = Havoc_DemonHunter_Talents,
  #                         "Vengeance Demon Hunter" = Vengeance_DemonHunter_Talents,
  #                         "Guardian Druid" = Guardian_Druid_Talents,
  #                         "Balance Druid" = Balance_Druid_Talents,
  #                         "Restoration Druid" = Restoration_Druid_Talents,
  #                         "Feral Druid" = Feral_Druid_Talents,
  #                         "Frost Mage" = Frost_Mage_Talents,
  #                         "Fire Mage" = Fire_Mage_Talents,
  #                         "Arcane Mage" = Arcane_Mage_Talents,
  #                         "Mistweaver Monk" = Mistweaver_Monk_Talents,
  #                         "Brewmaster Monk" = Brewmaster_Monk_Talents,
  #                         "Windwalker Monk" = Windwalker_Monk_Talents,
  #                         "Holy Paladin" = Holy_Paladin_Talents,
  #                         "Protection Paladin" = Protection_Paladin_Talents,
  #                         "Retribution Paladin" = Retribution_Paladin_Talents,
  #                         "Holy Priest" = Holy_Priest_Talents,
  #                         "Shadow Priest" = Shadow_Priest_Talents,
  #                         "Discipline Priest" = Discipline_Priest_Talents,
  #                         "Subtlety Rogue" = Subtlety_Rogue_Talents,
  #                         "Assassination Rogue" = Assassination_Rogue_Talents,
  #                         "Outlaw Rogue" = Outlaw_Rogue_Talents,
  #                         "Restoration Shaman" = Restoration_Shaman_Talents,
  #                         "Elemental Shaman" = Elemental_Shaman_Talents,
  #                         "Enhancement Shaman" = Enhancement_Shaman_Talents,
  #                         "Destruction Warlock" = Destruction_Warlock_Talents,
  #                         "Affliction Warlock" = Affliction_Warlock_Talents,
  #                         "Demonology Warlock" = Demonology_Warlock_Talents,
  #                         "Arms Warrior" = Arms_Warrior_Talents,
  #                         "Fury Warrior" = Fury_Warrior_Talents,
  #                         "Protection Warrior" = Protection_Warrior_Talents
  # )
  
  
  specs_df = data.frame("DeathKnight" = c("Blood","Frost","Unholy","Blood",NA),
                        "DemonHunter" = c("Havoc","Vengeance","Havoc",NA,NA),
                        "Druid" = c("Balance", "Feral", "Guardian","Restoration", "Balance"),
                        "Hunter" = c("Beast Mastery", "Marksmanship", "Survival", "Beast Mastery",NA),
                        "Mage" = c("Arcane","Fire","Frost","Arcane",NA),
                        "Monk" = c("Brewmaster","Mistweaver","Windwalker","Brewmaster",NA),
                        "Paladin" = c("Holy","Protection","Retribution","Holy",NA),
                        "Priest" = c("Discipline","Holy","Shadow","Discipline",NA),
                        "Rogue" = c("Assassination","Outlaw","Subtlety","Assassination",NA),
                        "Shaman" = c("Elemental","Enhancement","Restoration","Elemental",NA),
                        "Warlock" = c("Affliction","Demonology","Destruction","Affliction",NA),
                        "Warrior" = c("Arms","Fury","Protection","Arms",NA)
                        
  )
  specs = c("Fury","Arms","Protection", "Retribution", "Holy", "Elemental", "Restoration", "Enhancement",
            "Feral", "Guardian","Balance", "Beast Mastery", "Survival", "Marksmanship","Shadow","Discipline",
            "Assassination","Subtlety","Outlaw","Frost","Fire","Arcane","Brewmaster","Windwalker","Mistweaver",
            "Blood","Unholy","Havoc","Vengeance","Affliction","Demonology","Destruction")
  classes = c("Warrior", "Paladin", "Shaman","Druid","Hunter", "Priest","Rogue","Mage","Monk","Death Knight", 
              "Warlock", "Demon Hunter")
  spec_class = c("Fury Warrior", "Arms Warrior", "Protection Warrior", "Protection Paladin", "Retribution Paladin",
                 "Holy Paladin", "Elemental Shaman", "Restoration Shaman", "Enhancement Shaman", "Feral Druid",
                 "Guardian Druid", "Balance Druid", "Restoration Druid", "Beast Mastery Hunter", "Survival Hunter",
                 "Marksmanship Hunter", "Shadow Priest", "Discipline Priest", "Holy Priest", "Assassination Rogue",
                 "Subtlety Rogue", "Outlaw Rogue", "Frost Mage", "Fire Mage", "Arcane Mage", "Brewmaster Monk",
                 "Windwalker Monk", "Mistweaver Monk", "Blood Death Knight","Unholy Death Knight", "Frost Death Knight",
                 "Havoc Demon Hunter", "Vengeance Demon Hunter", "Affliction Warlock", "Demonology Warlock", "Destruction Warlock")
  
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
      ylim(0,175) +
      theme(axis.text.x = element_text(angle = 90, size = 11))
    
    piechart = ggplot(pie_df, aes(x = "", y = Freq, fill = factions)) + geom_bar(stat = "identity") +
      coord_polar("y", start = 0) +
      ggtitle(label = paste0("Horde and Alliance population comparison for the ", input$variable, " bracket")) +
      scale_fill_manual(values = c("blue1","red1"))
    
    
    # print(num_hor)
    # print(num_ali)
    
    ## ASSIGN SUDO GLOBALS
    # assign("char_server",char_server,.GlobalEnv)
    # assign("char_name",char_name,.GlobalEnv)
    # assign("classes_vec",classes_vec,.GlobalEnv)
    # assign("spec_vec",spec_vec,.GlobalEnv)
    # assign("spec_class_vec",spec_class_vec,.GlobalEnv)
    # assign("specs_df",specs_df,.GlobalEnv)
    
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
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

