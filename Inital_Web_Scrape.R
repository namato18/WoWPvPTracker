library(purrr)
library(httr)
library(jsonlite)

# 
# 
# 
# 
# 
# 
# 
# 
# 
# possible_read = possibly(.f = read_html, otherwise = "ERROR")
# possibly_read = possibly(.f = GET, otherwise = "ERROR")
# 
# 
# talent_extract = read_html("https://worldofwarcraft.com/en-us/game/talent-calculator#death-knight/blood") %>%
#   html_nodes(".Talent")
# talent_extract = html_text(talent_extract)
# test_text_extract = str_extract(talent_extract, "(.*?)\\(")
# test_text_extract = str_replace(test_text_extract, "\\(", "")
# test_text_extract = test_text_extract[-1]
# test_text_extract = test_text_extract[!is.na(test_text_extract)]
# 
# current_date = Sys.time()
# current_date = str_match(current_date, ".{10}")[1]
# 
# ## Need to create a data.frame of all classes with their specs/talents
# 
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
# 
# 
# specs_df = data.frame("DeathKnight" = c("Blood","Frost","Unholy","Blood",NA),
#                       "DemonHunter" = c("Havoc","Vengeance","Havoc",NA,NA),
#                       "Druid" = c("Balance", "Feral", "Guardian","Restoration", "Balance"),
#                       "Hunter" = c("Beast Mastery", "Marksmanship", "Survival", "Beast Mastery",NA),
#                       "Mage" = c("Arcane","Fire","Frost","Arcane",NA),
#                       "Monk" = c("Brewmaster","Windwalker","Mistweaver","Brewmaster",NA),
#                       "Paladin" = c("Holy","Protection","Retribution","Holy",NA),
#                       "Priest" = c("Discipline","Holy","Shadow","Discipline",NA),
#                       "Rogue" = c("Assassination","Outlaw","Subtlety","Assassination",NA),
#                       "Shaman" = c("Elemental","Enhancement","Restoration","Elemental",NA),
#                       "Warlock" = c("Affliction","Demonology","Destruction","Affliction",NA),
#                       "Warrior" = c("Arms","Fury","Protection","Arms",NA)
# )
# 
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
# 
# specs = c("Fury","Arms","Protection", "Retribution", "Holy", "Elemental", "Restoration", "Enhancement",
#           "Feral", "Guardian","Balance", "Beast Mastery", "Survival", "Marksmanship","Shadow","Discipline",
#           "Assassination","Subtlety","Outlaw","Frost","Fire","Arcane","Brewmaster","Windwalker","Mistweaver",
#           "Blood","Unholy","Havoc","Vengeance","Affliction","Demonology","Destruction")
# classes = c("Warrior", "Paladin", "Shaman","Druid","Hunter", "Priest","Rogue","Mage","Monk","Death Knight", 
#             "Warlock", "Demon Hunter")
# spec_class = c("Fury Warrior", "Arms Warrior", "Protection Warrior", "Protection Paladin", "Retribution Paladin",
#                "Holy Paladin", "Elemental Shaman", "Restoration Shaman", "Enhancement Shaman", "Feral Druid",
#                "Guardian Druid", "Balance Druid", "Restoration Druid", "Beast Mastery Hunter", "Survival Hunter",
#                "Marksmanship Hunter", "Shadow Priest", "Discipline Priest", "Holy Priest", "Assassination Rogue",
#                "Subtlety Rogue", "Outlaw Rogue", "Frost Mage", "Fire Mage", "Arcane Mage", "Brewmaster Monk",
#                "Windwalker Monk", "Mistweaver Monk", "Blood Death Knight","Unholy Death Knight", "Frost Death Knight",
#                "Havoc Demon Hunter", "Vengeance Demon Hunter", "Affliction Warlock", "Demonology Warlock", "Destruction Warlock")

possible_get = possibly(.f = httr::GET, otherwise = 'ERROR')
possible_json = possibly(.f = jsonlite::fromJSON, otherwise = 'ERROR' )

bracket = c("2v2","3v3","rbg")
start.time = Sys.time()

access_token = system("curl -u 6ab02cc1a1c140f0bd213d0b27e8c74c:VTrUzsJw0XDmKfJvM1QIXpn1QC1Hs96e -d grant_type=client_credentials https://us.battle.net/oauth/token",
                      intern = TRUE)
# For running on PC
access_token = jsonlite::fromJSON(access_token[4], flatten = TRUE)

# For running on MAC
#access_token = jsonlite::fromJSON(access_token, flatten = TRUE)
access_token = access_token$access_token

## USING WOW API

#Get the current pvp season
get_season_url = paste0("https://us.api.blizzard.com/data/wow/pvp-season/index?namespace=dynamic-us&locale=en_US&access_token=",access_token)

season_get = httr::GET(get_season_url)

season_get$status_code

season = rawToChar(season_get$content)

season = possible_json(season, flatten = TRUE)
current_season = season$current_season$id

for(n in 1:3){
  
  # Get the standings list for the current season
  
  get_standings_url = paste0("https://us.api.blizzard.com/data/wow/pvp-season/",current_season,"/pvp-leaderboard/",bracket[n],"?namespace=dynamic-us&locale=en_US&access_token=",access_token)
  
  standings_get = httr::GET(get_standings_url)
  
  standings_get$status_code
  
  standings = rawToChar(standings_get$content)
  
  standings = possible_json(standings, flatten = TRUE)
  standings = data.frame(standings$entries)
  
  factions = standings$faction.type
  
  factions = data.frame(table(factions))
  
  top_players = tolower(standings$character.name)
  player_realm = tolower(standings$character.realm.slug)
  
  
  
  assign(paste0("top_players_",bracket[3]), top_players, .GlobalEnv)
  assign(paste0("player_realm",bracket[3]), player_realm, .GlobalEnv)
  
  spec_vec = c()
  class_vec = c()
  
  talents_df = data.frame(Class = NA,
                          Spec = NA,
                          Talent = NA,
                          Talent.Level = NA,
                          Spec.Class = NA,
                          Char.Name = NA)
  
  pvp_talents_df = data.frame(Class = NA,
                              Spec = NA,
                              PvP.Talent = NA,
                              Spec.Class = NA,
                              Char.Name = NA)
  
  for(j in 1:length(top_players)){
    get_talents_url = URLencode(paste0("https://us.api.blizzard.com/profile/wow/character/",player_realm[j],"/",top_players[j],"/specializations?namespace=profile-us&locale=en_US&access_token=",access_token))
    get_class_url = URLencode(paste0("https://us.api.blizzard.com/profile/wow/character/",player_realm[j],"/",top_players[j],"?namespace=profile-us&locale=en_US&access_token=",access_token))
    
    talents_get = possible_get(get_talents_url)
    class_get = possible_get(get_class_url)
    
    if(talents_get != 'ERROR' & class_get != 'ERROR'){
      
    
    
    talents_get$status_code
    class_get$status_code
    
    if(talents_get$status_code == 404 | class_get$status_code == 404){
      next()
    }
    
    talents = rawToChar(talents_get$content)
    class = rawToChar(class_get$content)
    
    
    class = possible_json(class, flatten = TRUE)
    talents_ = possible_json(talents, flatten = TRUE)
    
    if(class == 'ERROR' | talents_ == 'ERROR'){
      next()
    }
    
    class = class$character_class$name
    spec = talents_$active_specialization$name
    selected_index = which(talents_$specializations$specialization.name == spec)
    talents = talents_$specializations$talents[[selected_index]]$talent.name
    pvp_talents = talents_$specializations$pvp_talent_slots[[selected_index]]$selected.talent.name
    print(talents)
    print(pvp_talents)
    print(j)
    if(length(talents) != 7 | length(pvp_talents) != 3){
      print('FOUND IT')
      next()
    }
    
    class_vec = append(class_vec, class)
    spec_vec = append(spec_vec, spec)
    
    for(k in 1:length(talents)){
      x = data.frame(
        Class = class,
        Spec = spec,
        Talent = talents[k],
        Talent.Level = NA,
        Spec.Class = paste0(spec,".",class),
        Char.Name = top_players[j]
      )
      
      talents_df = rbind(talents_df, x)
    }
    
    for(k in 1:length(pvp_talents)){
      x = data.frame(Class = class,
                     Spec = spec,
                     PvP.Talent = pvp_talents[k],
                     Spec.Class = paste0(spec,".",class),
                     Char.Name = top_players[j])
      pvp_talents_df = rbind(pvp_talents_df, x)
    }
    }else{
      print('ERROR FOUND')
      next()
    }
  }
  talents_df = talents_df[-1,]
  pvp_talents_df = pvp_talents_df[-1,]
  talents_df$Talent.Level = rep(c(15,25,30,35,40,45,50), nrow(talents_df)/7)
  
  class_spec_df = data.frame(cbind(class_vec,spec_vec))
  class_spec_df$spec_class = paste0(spec_vec,".",class_vec)
  class_spec_counts = data.frame(table(class_spec_df$spec_class))
  for(h in 1:nrow(class_spec_counts)){
    class_spec_counts$spec[h] = strsplit(toString(class_spec_counts$Var1[h]), ".", fixed = TRUE)[[1]][1]
    class_spec_counts$class[h] = strsplit(toString(class_spec_counts$Var1[h]), ".", fixed = TRUE)[[1]][2]
  }
  
  write.csv(factions, paste0("pie_df_",bracket[n],".",Sys.Date(),".csv"), row.names = FALSE)
  write.csv(talents_df, paste0("talents_df_",bracket[n],".",Sys.Date(),".csv"), row.names = FALSE)
  write.csv(class_spec_counts, paste0("uniq_",bracket[n],".",Sys.Date(),".csv"), row.names = FALSE)
  write.csv(pvp_talents_df, paste0("pvp_talents_df_",bracket[n],".",Sys.Date(),".csv"), row.names = FALSE)
  
}
total.time = start.time - Sys.time()
print(total.time)
# 
# test = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n])) %>%
#   html_nodes(".Character")
# test1 = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n])) %>%
#   html_nodes(".List-item")
# char_faction = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n])) %>%
#   html_nodes(".SortTable-col")
# char_class = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n])) %>%
#   html_nodes(".Character-level")
# char_faction_text = html_text(char_faction)
# num_ali = length(grep("Alliance", char_faction_text))
# num_hor = length(grep("Horde", char_faction_text))
# 
# 
# class_text = html_text(char_class)
# class_text = gsub("60","",class_text)
# for(i in 1:length(class_text)){
#   for(j in 1:length(specs)){
#     class_text[i] = gsub(specs[j],"",class_text[i])
#   }
# }
# class_text = gsub(" ","", class_text)
# 
# text = html_text(test)
# text1 = html_text(test1)
# 
# text1 = str_extract(string = text1, pattern = "\\d{4}")
# index = which(!is.na(text1))
# text1 = text1[index]
# 
# text = str_remove_all(string = text, pattern = "60")
# 
# 
# 
# # Check spec list for what spec this character is
# # for(i in 1:length(specs)){
# #   if(grepl(specs[i], spec_text)){
# #     print(specs[i])
# #   }
# # }
# 
# 
# 
# # talent_vec = c()
# # for(i in 1:length(spec_class)){
# #   ind = grep(spec_class[1], dftest$classspec)
# #   names = dftest$char_name[ind]
# #   server = dftest$char_server[ind]
# #   server = gsub(" ","-",server)
# #   for(j in 1:length(names)){
# #     charpage = read_html(paste0("https://worldofwarcraft.com/en-us/character/us/",server[1],"/",names[1]))
# #     charpage_txt = html_text(charpage)
# # 
# #     for(k in 1:length(Fury_Warrior_Talents)){
# #       if(grepl(Fury_Warrior_Talents[k], charpage_txt)){
# #         talent_vec = append(talent_vec,Fury_Warrior_Talents[k])
# #       }
# #     }
# # 
# # 
# #   }
# # }
# 
# #str_split(string = test, pattern = " ")
# 
# spec_vec = c()
# classes_vec = c()
# 
# for(i in 1:length(text)){
#   for(j in 1:length(specs)){
#     if(grepl(paste0("\\b",specs[j],"\\b"), text[i])){
#       spec_vec = append(spec_vec, specs[j])
#       break()
#     }
#   }
#   next()
# }
# for(i in 1:length(text)){
#   for(j in 1:length(classes)){
#     if(grepl(classes[j], text[i], fixed = TRUE)){
#       classes_vec = append(classes_vec, classes[j])
#       break()
#     }
#   }
#   next()
# }
# ## Checking out talents
# char_name = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n])) %>%
#   html_nodes(".Character-name")
# char_server = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n])) %>%
#   html_nodes(".Character-realm")
# 
# char_name = html_text(char_name)
# char_server = html_text(char_server)
# 
# 
# important_df = data.frame("Class" = "",
#                           "Spec" = "",
#                           "Talent" = "",
#                           "Talent Level" = "",
#                           "Character.Name" = "")
# 
# 
# for(i in 2:10){
#   test = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n],"?page=",i)) %>%
#     html_nodes(".Character")
#   test1 = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n],"?page=",i)) %>%
#     html_nodes(".List-item")
#   char_faction = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n],"?page=",i)) %>%
#     html_nodes(".SortTable-col")
#   char_class2 = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n],"?page=",i)) %>%
#     html_nodes(".Character-level")
#   char_name2 = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n],"?page=",i)) %>%
#     html_nodes(".Character-name")
#   char_server2 = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n],"?page=",i)) %>%
#     html_nodes(".Character-realm")
#   
#   char_name2 = html_text(char_name2)
#   char_server2 = html_text(char_server2)
#   char_server2 = str_replace(char_server2,"'","")
#   char_server2 = str_replace(char_server2," ","-")
#   char_server2 = str_replace(char_server2,"Azjol-Nerub","azjolnerub")
#   
#   char_name = append(char_name, char_name2)
#   char_server = append(char_server, char_server2)
#   char_faction_text = html_text(char_faction)
#   num_ali2 = length(grep("Alliance", char_faction_text))
#   num_hor2 = length(grep("Horde", char_faction_text))
#   
#   num_ali = num_ali + num_ali2
#   num_hor = num_hor + num_hor2
#   
#   char_server = str_replace(char_server,"'","")
#   char_server = str_replace(char_server," ","-")
#   char_server = str_replace(char_server,"Azjol-Nerub","azjolnerub")
#   
#   
#   class_text2 = html_text(char_class2)
#   class_text2 = gsub("60","",class_text2)
#   for(i in 1:length(class_text2)){
#     for(j in 1:length(specs)){
#       class_text2[i] = gsub(specs[j],"",class_text2[i])
#     }
#   }
#   class_text2 = gsub(" ","", class_text2)
#   class_text = append(class_text, class_text2)
#   
#   text = html_text(test)
#   text1 = html_text(test1)
#   
#   text1 = str_extract(string = text1, pattern = "\\d{4}")
#   
#   text = str_remove_all(string = text, pattern = "60")
#   
#   for(k in 1:length(text)){
#     for(j in 1:length(specs)){
#       if(grepl(paste0("\\b",specs[j],"\\b"), text[k])){
#         spec_vec = append(spec_vec, specs[j])
#         break()
#       }
#     }
#     next()
#   }
#   for(k in 1:length(text)){
#     for(j in 1:length(classes)){
#       if(grepl(classes[j], text[k], fixed = TRUE)){
#         classes_vec = append(classes_vec, classes[j])
#         break()
#       }
#     }
#     next()
#   }
# }
# 
# pie_df = data.table(Faction = c("Horde","Alliance"),
#                     Count = c(num_hor, num_ali))
# 
# df = data.frame("spec" = spec_vec,
#                 "class" = classes_vec)
# #df = df[,-1]
# df$class[df$spec == "Havoc" & df$class == "Hunter"] = "Demon Hunter"
# df$class[df$spec == "Vengeance" & df$class == "Hunter"] = "Demon Hunter"
# 
# uniq = unique(df[c("spec","class")])
# 
# df$count = NA
# 
# 
# for(i in 1:length(specs)){
#   
#   indexs = which(df$spec == specs[i])
#   specs_ = df[c(indexs),]
#   unique_classes = unique(specs_["class"])
#   for(j in 1:nrow(unique_classes)){
#     class_count = length(which(specs_$class == unique_classes$class[j]))
#     uniq$count[specs[i] == uniq$spec & unique_classes$class[j] == uniq$class] = class_count
#   }
#   #uniq$count[specs[i] == uniq$spec] = indexs
#   
# }
# 
# spec_class_vec = paste(spec_vec,classes_vec, sep = " ")
# spec_class_vec = str_replace(spec_class_vec," ",".")
# spec_class_vec = str_replace(spec_class_vec,"Havoc.Hunter", "Havoc.Demon.Hunter")
# spec_class_vec = str_replace(spec_class_vec,"Vengeance.Hunter", "Vengeance.Demon.Hunter")
# spec_class_vec = str_replace(spec_class_vec,"Beast.Mastery Hunter", "Beast.Mastery.Hunter")
# spec_class_vec = str_replace(spec_class_vec,"Unholy.Death Knight", "Unholy.Death.Knight")
# spec_class_vec = str_replace(spec_class_vec,"Blood.Death Knight", "Blood.Death.Knight")
# spec_class_vec = str_replace(spec_class_vec,"Frost.Death Knight", "Frost.Death.Knight")
# 
# 
# server_name_class = cbind(char_server, char_name, class_text)
# 
# # for(i in 1:nrow(server_name_class)){
# for(i in 1:nrow(server_name_class)){
#   
#   sub_spec = select(specs_df, class_text[i])
#   for(j in 1:nrow(sub_spec)){
#     if(grepl(spec_vec[i], sub_spec[j,])){
#       index = j
#       break()
#     }
#   }
#   
#   #test_character = read_html(URLencode("https://worldofwarcraft.com/en-us/character/us/shadowmoon/xiuni"))
# 
#   urlAddress = tolower(URLencode(paste0("https://worldofwarcraft.com/en-us/character/us/",char_server[i],"/",char_name[i])))
#   print(urlAddress)
#   test_character = (possible_read(urlAddress))
#   if(test_character == "ERROR"){
#     next()
#   }
#   test_char_text = html_text(test_character)
#   
#   #test_char_text = str_extract(test_char_text, paste0("Holy","\",\"pvpTalents(.*?)","Shadow","\",\"pvpTalents"))
#   
#   test_char_text = str_extract(test_char_text, paste0(sub_spec[index,],"\",\"pvpTalents(.*?)",sub_spec[index + 1,],"\",\"pvpTalents"))
#   test_char_text = str_replace_all(test_char_text,"description.*?icon","")
#   test_char_text = str_replace_all(test_char_text,"talent-calculator.*Requires Level","")
#   test_char_text = str_replace_all(test_char_text,"set\\\".*item-set","")
#   
#   test_char_text = unique(str_match_all(test_char_text, paste0("name\\\":\\\"(.*?)\\\""))[[1]][,2])[4:10]
# 
#   
# # Create row for each talent
#   
#   for(j in 1:length(test_char_text)){
#     print(paste0(n," ",i))
#     df1 = data.frame("Class" = class_text[i],
#                    "Spec" = spec_vec[i],
#                    "Talent" = test_char_text[j],
#                    "Talent Level" = "",
#                    "Character.Name" = char_name[i])
#     important_df = rbind(important_df,df1)
#   }
#   
#   #sub_df = select(talents_df, spec_class_vec[i])
#   
#   # for(j in 1:nrow(sub_df)){
#   #   if(grepl(sub_df[j,], test_char_text)){
#   #     print(paste0(n," ",i))
#   #     
#   #     df = data.frame("Class" = class_text[i],
#   #                     "Spec" = spec_vec[i],
#   #                     "Talent" = sub_df[j,],
#   #                     "Talent Level" = "",
#   #                     "Character.Name" = char_name[i])
#   #     important_df = rbind(important_df,df)
#   #     
#   #   }
#   # }
# }
# important_df = important_df[-1,]
# important_df$Spec.Class = paste(important_df$Spec,important_df$Class,sep = ".")
# to_remove = pull(important_df, Talent)
# to_remove = which(is.na(to_remove))
# important_df = important_df[-c(to_remove),]
# 
# write.csv(pie_df, paste0("pie_df_",bracket[n],".csv"), row.names = FALSE)
# write.csv(important_df, paste0("important_df_",bracket[n],".csv"), row.names = FALSE)
# write.csv(uniq, paste0("uniq_",bracket[n],".csv"), row.names = FALSE)
#}