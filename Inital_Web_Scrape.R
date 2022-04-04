talent_extract = read_html("https://worldofwarcraft.com/en-us/game/talent-calculator#death-knight/blood") %>%
  html_nodes(".Talent")
talent_extract = html_text(talent_extract)
test_text_extract = str_extract(talent_extract, "(.*?)\\(")
test_text_extract = str_replace(test_text_extract, "\\(", "")
test_text_extract = test_text_extract[-1]
test_text_extract = test_text_extract[!is.na(test_text_extract)]

current_date = Sys.time()
current_date = str_match(current_date, ".{10}")[1]

## Need to create a data.frame of all classes with their specs/talents

Blood_DeathKnight_Talents = c(test_text_extract[1:21])
Frost_DeathKnight_Talents = c(test_text_extract[22:42])
Unholy_DeathKnight_Talents = c(test_text_extract[43:63])

Havoc_DemonHunter_Talents = c(test_text_extract[64:84])
Vengeance_DemonHunter_Talents = c(test_text_extract[85:105])

Balance_Druid_Talents = c(test_text_extract[106:126])
Feral_Druid_Talents = c(test_text_extract[127:147])
Guardian_Druid_Talents = c(test_text_extract[148:168])
Restoration_Druid_Talents = c(test_text_extract[169:189])

BeastMastery_Hunter_Talents = c(test_text_extract[190:210])
Marksman_Hunter_Talents = c(test_text_extract[211:231])
Survival_Hunter_Talents = c(test_text_extract[232:252])

Arcane_Mage_Talents = c(test_text_extract[253:273])
Fire_Mage_Talents = c(test_text_extract[274:294])
Frost_Mage_Talents = c(test_text_extract[295:315])

Brewmaster_Monk_Talents = c(test_text_extract[316:336])
Mistweaver_Monk_Talents = c(test_text_extract[337:357])
Windwalker_Monk_Talents = c(test_text_extract[358:378])

Holy_Paladin_Talents = c(test_text_extract[379:399])
Protection_Paladin_Talents= c(test_text_extract[400:420])
Retribution_Paladin_Talents = c(test_text_extract[421:441])

Discipline_Priest_Talents = c(test_text_extract[442:462])
Holy_Priest_Talents = c(test_text_extract[463:483])
Shadow_Priest_Talents = c(test_text_extract[484:504])

Assassination_Rogue_Talents = c(test_text_extract[505:525])
Outlaw_Rogue_Talents = c(test_text_extract[526:546])
Subtlety_Rogue_Talents = c(test_text_extract[547:567])

Elemental_Shaman_Talents = c(test_text_extract[568:588])
Enhancement_Shaman_Talents = c(test_text_extract[589:609])
Restoration_Shaman_Talents = c(test_text_extract[610:630])

Affliction_Warlock_Talents = c(test_text_extract[631:651])
Demonology_Warlock_Talents = c(test_text_extract[652:672])
Destruction_Warlock_Talents = c(test_text_extract[673:693])

Arms_Warrior_Talents = c(test_text_extract[694:714])
Fury_Warrior_Talents = c(test_text_extract[715:735])
Protection_Warrior_Talents = c(test_text_extract[736:756])


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


talents_df = data.frame("Survival Hunter" = Survival_Hunter_Talents,
                        "Marksmanship Hunter" = Marksman_Hunter_Talents,
                        "Beast Mastery Hunter" = BeastMastery_Hunter_Talents,
                        "Blood Death Knight" = Blood_DeathKnight_Talents,
                        "Frost Death Knight" = Frost_DeathKnight_Talents,
                        "Unholy Death Knight" = Unholy_DeathKnight_Talents,
                        "Havoc Demon Hunter" = Havoc_DemonHunter_Talents,
                        "Vengeance Demon Hunter" = Vengeance_DemonHunter_Talents,
                        "Guardian Druid" = Guardian_Druid_Talents,
                        "Balance Druid" = Balance_Druid_Talents,
                        "Restoration Druid" = Restoration_Druid_Talents,
                        "Feral Druid" = Feral_Druid_Talents,
                        "Frost Mage" = Frost_Mage_Talents,
                        "Fire Mage" = Fire_Mage_Talents,
                        "Arcane Mage" = Arcane_Mage_Talents,
                        "Mistweaver Monk" = Mistweaver_Monk_Talents,
                        "Brewmaster Monk" = Brewmaster_Monk_Talents,
                        "Windwalker Monk" = Windwalker_Monk_Talents,
                        "Holy Paladin" = Holy_Paladin_Talents,
                        "Protection Paladin" = Protection_Paladin_Talents,
                        "Retribution Paladin" = Retribution_Paladin_Talents,
                        "Holy Priest" = Holy_Priest_Talents,
                        "Shadow Priest" = Shadow_Priest_Talents,
                        "Discipline Priest" = Discipline_Priest_Talents,
                        "Subtlety Rogue" = Subtlety_Rogue_Talents,
                        "Assassination Rogue" = Assassination_Rogue_Talents,
                        "Outlaw Rogue" = Outlaw_Rogue_Talents,
                        "Restoration Shaman" = Restoration_Shaman_Talents,
                        "Elemental Shaman" = Elemental_Shaman_Talents,
                        "Enhancement Shaman" = Enhancement_Shaman_Talents,
                        "Destruction Warlock" = Destruction_Warlock_Talents,
                        "Affliction Warlock" = Affliction_Warlock_Talents,
                        "Demonology Warlock" = Demonology_Warlock_Talents,
                        "Arms Warrior" = Arms_Warrior_Talents,
                        "Fury Warrior" = Fury_Warrior_Talents,
                        "Protection Warrior" = Protection_Warrior_Talents
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

bracket = c("2v2","3v3","battlegrounds")

for(n in 1:length(bracket)){
  


test = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n])) %>%
  html_nodes(".Character")
test1 = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n])) %>%
  html_nodes(".List-item")
char_faction = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n])) %>%
  html_nodes(".SortTable-col")
char_class = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n])) %>%
  html_nodes(".Character-level")
char_faction_text = html_text(char_faction)
num_ali = length(grep("Alliance", char_faction_text))
num_hor = length(grep("Horde", char_faction_text))


class_text = html_text(char_class)
class_text = gsub("60","",class_text)
for(i in 1:length(class_text)){
  for(j in 1:length(specs)){
    class_text[i] = gsub(specs[j],"",class_text[i])
  }
}
class_text = gsub(" ","", class_text)

text = html_text(test)
text1 = html_text(test1)

text1 = str_extract(string = text1, pattern = "\\d{4}")
index = which(!is.na(text1))
text1 = text1[index]

text = str_remove_all(string = text, pattern = "60")



# Check spec list for what spec this character is
# for(i in 1:length(specs)){
#   if(grepl(specs[i], spec_text)){
#     print(specs[i])
#   }
# }



# talent_vec = c()
# for(i in 1:length(spec_class)){
#   ind = grep(spec_class[1], dftest$classspec)
#   names = dftest$char_name[ind]
#   server = dftest$char_server[ind]
#   server = gsub(" ","-",server)
#   for(j in 1:length(names)){
#     charpage = read_html(paste0("https://worldofwarcraft.com/en-us/character/us/",server[1],"/",names[1]))
#     charpage_txt = html_text(charpage)
# 
#     for(k in 1:length(Fury_Warrior_Talents)){
#       if(grepl(Fury_Warrior_Talents[k], charpage_txt)){
#         talent_vec = append(talent_vec,Fury_Warrior_Talents[k])
#       }
#     }
# 
# 
#   }
# }

#str_split(string = test, pattern = " ")

spec_vec = c()
classes_vec = c()

for(i in 1:length(text)){
  for(j in 1:length(specs)){
    if(grepl(paste0("\\b",specs[j],"\\b"), text[i])){
      spec_vec = append(spec_vec, specs[j])
      break()
    }
  }
  next()
}
for(i in 1:length(text)){
  for(j in 1:length(classes)){
    if(grepl(classes[j], text[i], fixed = TRUE)){
      classes_vec = append(classes_vec, classes[j])
      break()
    }
  }
  next()
}
## Checking out talents
char_name = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n])) %>%
  html_nodes(".Character-name")
char_server = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n])) %>%
  html_nodes(".Character-realm")

char_name = html_text(char_name)
char_server = html_text(char_server)


important_df = data.frame("Class" = "",
                          "Spec" = "",
                          "Talent" = "",
                          "Talent Level" = "")


for(i in 2:10){
  test = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n],"?page=",i)) %>%
    html_nodes(".Character")
  test1 = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n],"?page=",i)) %>%
    html_nodes(".List-item")
  char_faction = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n],"?page=",i)) %>%
    html_nodes(".SortTable-col")
  char_class2 = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n],"?page=",i)) %>%
    html_nodes(".Character-level")
  char_name2 = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n],"?page=",i)) %>%
    html_nodes(".Character-name")
  char_server2 = read_html(paste0("https://worldofwarcraft.com/en-us/game/pvp/leaderboards/",bracket[n],"?page=",i)) %>%
    html_nodes(".Character-realm")
  
  char_name2 = html_text(char_name2)
  char_server2 = html_text(char_server2)
  char_server2 = str_replace(char_server2,"'","")
  char_server2 = str_replace(char_server2," ","-")
  char_server2 = str_replace(char_server2,"Azjol-Nerub","azjolnerub")
  
  char_name = append(char_name, char_name2)
  char_server = append(char_server, char_server2)
  char_faction_text = html_text(char_faction)
  num_ali2 = length(grep("Alliance", char_faction_text))
  num_hor2 = length(grep("Horde", char_faction_text))
  
  num_ali = num_ali + num_ali2
  num_hor = num_hor + num_hor2
  
  char_server = str_replace(char_server,"'","")
  char_server = str_replace(char_server," ","-")
  char_server = str_replace(char_server,"Azjol-Nerub","azjolnerub")
  
  
  class_text2 = html_text(char_class2)
  class_text2 = gsub("60","",class_text2)
  for(i in 1:length(class_text2)){
    for(j in 1:length(specs)){
      class_text2[i] = gsub(specs[j],"",class_text2[i])
    }
  }
  class_text2 = gsub(" ","", class_text2)
  class_text = append(class_text, class_text2)
  
  text = html_text(test)
  text1 = html_text(test1)
  
  text1 = str_extract(string = text1, pattern = "\\d{4}")
  
  text = str_remove_all(string = text, pattern = "60")
  
  for(k in 1:length(text)){
    for(j in 1:length(specs)){
      if(grepl(paste0("\\b",specs[j],"\\b"), text[k])){
        spec_vec = append(spec_vec, specs[j])
        break()
      }
    }
    next()
  }
  for(k in 1:length(text)){
    for(j in 1:length(classes)){
      if(grepl(classes[j], text[k], fixed = TRUE)){
        classes_vec = append(classes_vec, classes[j])
        break()
      }
    }
    next()
  }
}

pie_df = data.table(Faction = c("Horde","Alliance"),
                    Count = c(num_hor, num_ali))

df = data.frame("spec" = spec_vec,
                "class" = classes_vec)
#df = df[,-1]
df$class[df$spec == "Havoc" & df$class == "Hunter"] = "Demon Hunter"
df$class[df$spec == "Vengeance" & df$class == "Hunter"] = "Demon Hunter"

uniq = unique(df[c("spec","class")])

df$count = NA


for(i in 1:length(specs)){
  
  indexs = which(df$spec == specs[i])
  specs_ = df[c(indexs),]
  unique_classes = unique(specs_["class"])
  for(j in 1:nrow(unique_classes)){
    class_count = length(which(specs_$class == unique_classes$class[j]))
    uniq$count[specs[i] == uniq$spec & unique_classes$class[j] == uniq$class] = class_count
  }
  #uniq$count[specs[i] == uniq$spec] = indexs
  
}

spec_class_vec = paste(spec_vec,classes_vec, sep = " ")
spec_class_vec = str_replace(spec_class_vec," ",".")
spec_class_vec = str_replace(spec_class_vec,"Havoc.Hunter", "Havoc.Demon.Hunter")
spec_class_vec = str_replace(spec_class_vec,"Vengeance.Hunter", "Vengeance.Demon.Hunter")
spec_class_vec = str_replace(spec_class_vec,"Beast.Mastery Hunter", "Beast.Mastery.Hunter")
spec_class_vec = str_replace(spec_class_vec,"Unholy.Death Knight", "Unholy.Death.Knight")
spec_class_vec = str_replace(spec_class_vec,"Blood.Death Knight", "Blood.Death.Knight")
spec_class_vec = str_replace(spec_class_vec,"Frost.Death Knight", "Frost.Death.Knight")


server_name_class = cbind(char_server, char_name, classes_vec)

for(i in 1:length(char_name)){
  
  sub_spec = select(specs_df, class_text[i])
  for(j in 1:nrow(sub_spec)){
    if(grepl(spec_vec[i], sub_spec[j,])){
      index = j
      break()
    }
  }
  
  test_character = read_html(URLencode(paste0("https://worldofwarcraft.com/en-us/character/us/",char_server[i],"/",char_name[i])))
  test_char_text = html_text(test_character)
  test_char_text = str_extract(test_char_text, paste0(sub_spec[index,],"\",\"pvpTalents(.*?)",sub_spec[index + 1,],"\",\"pvpTalents"))
  test_char_text = str_replace_all(test_char_text,"description.*?icon","")
  
  # grepl("Chi Torpedo", test_char_text)
  
  # grab the talents for the specific player
  sub_df = select(talents_df, spec_class_vec[i])
  
  for(j in 1:nrow(sub_df)){
    if(grepl(sub_df[j,], test_char_text)){
      print(i)
      
      df = data.frame("Class" = class_text[i],
                      "Spec" = spec_vec[i],
                      "Talent" = sub_df[j,],
                      "Talent Level" = "")
      important_df = rbind(important_df,df)
      
    }
  }
}
important_df = important_df[-1,]
important_df$Spec.Class = paste(important_df$Spec,important_df$Class,sep = ".")

write.csv(pie_df, paste0("~/Desktop/Rstuff/Initial_Scrape/pie_df_",bracket[n],".csv"), row.names = FALSE)
write.csv(important_df, paste0("~/Desktop/Rstuff/Initial_Scrape/important_df_",bracket[n],".csv"), row.names = FALSE)
write.csv(uniq, paste0("~/Desktop/Rstuff/Initial_Scrape/uniq_",bracket[n],".csv"), row.names = FALSE)
}