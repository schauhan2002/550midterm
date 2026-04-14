## Midterm Report Element #1 (Christina)

cleandata <- readRDS(
  file = here::here("data/cleandata.rds")
)

#Relabel columns for clean display
var_label(cleandata) <- list(subjid = "Subject ID",
                               site = "Site",
                               agemons = "Age (months)", 
                               sex = "Sex", 
                               caregiver = "Main caregiver",
                               other_carer = "Other caregiver",
                               bfeeding = "Breastfeeding (Y/N)", 
                               muac = "MUAC at baseline (cm)", 
                               weight = "Weight at baseline (kgs)", 
                               height = "Height/Length at baseline (cm)", 
                               hmeasure = "Measurement at baseline", 
                               oedema = "Oedema at baseline", 
                               shock = "Shock requiring fluid (Y/N)",
                               iconsciousness = "Impaired consciousness (Y/N)", 
                               sev_pneumonia = "Severe pneumonia (Y/N)", 
                               diarrhoea = "Diarrheoa (Y/N)", 
                               malaria = "Malaria (Y/N)", 
                               ofillness = "Other febrile illness (Y/N)", 
                               fappetitte = "Failed appetite test (Y/N)", 
                               milkfeed = "Received F75 milk prior (Y/N)",
                               tb = "Tuberculosis (Y/N)", 
                               chronic_cough = "Chronic cough (Y/N)", 
                               sickle_cell = "Sickle cell disease (Y/N)",
                               heart_disease = "Known heart disease (Y/N)", 
                               cerebral_palsy = "Cerebral palsy (Y/N)", 
                               enr_month = "Month of Enrollment",
                               hiv_results = "HIV antibody results", 
                               kwash = "Kwashiorkor (Y/N)", 
                               arm = "Randomization arm",
                               muac1 = "MUAC at stabilization (cm)", 
                               weight1 = "Weight at stabilization (kg)",
                               oedema1 = "Oedema at stabilization", 
                               absence_who1 = "Absence of WHO danger signs (Y/N)", 
                               complete_f751 = "Completed F75 (Y/N)",
                               receive_f751 = "Received F75 (Y/N)",
                               discharged2 = "Discharged as planned (Y/N)", 
                               muac2 = "MUAC at discharge (cm)", 
                               weight2 = "Weight at discharge (kg)", 
                               height2 = "Height/Length at discharge (cm)", 
                               measure2 = "Measurement at discharge", 
                               oedema2 = "Oedema at discharge", 
                               withdraw2 = "Reason for withdrawal", 
                               days_stable = "Days to stabilization")

#To display column names nicely, plot_missing doesn't automatically work with labelled
f75_interim_plot <- cleandata 
var_labels <- var_label(f75_interim_plot)
names(f75_interim_plot) <- ifelse(sapply(var_labels, is.null), 
                                  names(f75_interim_plot),unlist(var_labels))
#Create plot
missing_data_plot <- plot_missing(f75_interim_plot, 
                                  group_color = list(Good = "#E4B7E5", OK = "#B288C0", Bad = "#7E5A9B", Remove = "#63458A"), #coolors.com palette, colorblind friendly
                                  missing_only = TRUE, #Only show variables with any missing data
                                  title = glue("Missing Data"), 
                                  ggtheme = theme_classic()) #can change to any ggplot2 theme

#Save plot for report
saveRDS(
  missing_data_plot,
  file = here::here("output/missing_data_plot.rds")
)

table1 <- cleandata |> #Exclude subject ID, site (because is column), and arm (because parameter)
  tbl_summary(include = c(agemons, sex, caregiver, bfeeding, muac, weight, height, hmeasure, oedema, shock,
                          iconsciousness, sev_pneumonia, diarrhoea, malaria, ofillness, fappetitte, milkfeed,
                          tb, chronic_cough, heart_disease, cerebral_palsy, hiv_results, kwash, muac1, weight1,
                          oedema1, absence_who1, discharged2, muac2, weight2, 
                          height2, measure2, oedema2, withdraw2, days_stable), 
              missing = "ifany", missing_text = "Not recorded", #Show missing counts since is significant
              by = site) |> #Columns show characteristics by site
  modify_spanning_header(c("stat_1", "stat_2", "stat_3") ~ "**Site**") |> #Add label for site columns
  add_overall() |> #Overall column
  bold_labels() |> #Format bold labels
  modify_caption(glue("**Table 1. Patient Characteristics**")) |> #Caption label
  as_gt() |> #Coerce to gt for following function...
  gt::tab_source_note(gt::md("*Missing data coded as 'Not recorded'*")) #Modify footnote

#did not include: other_carer (messy values), 
#                 complete_f751 (not in data dictionary), 
#                 receive_f751 (not in data dictionary)

#Save table1 for report
saveRDS(
  table1,
  file = here::here("output/table_one.rds"))
