# Load necessary packages
library(tidyverse)

# Load the data
responses <- read_csv('datasets/kagglesurvey.csv')

# Print the first 10 rows
head(responses, n = 10)

# Printing the first respondent's tools and languages
responses[1, 2]

# Add a new column, and unnest the new column
tools <- responses  %>% 
    mutate(work_tools = str_split(WorkToolsSelect, ","))  %>% 
    unnest(work_tools)

# View the first 6 rows of tools
head(tools)


# Group the data by work_tools, summarise the counts, and arrange in descending order
tool_count <- tools  %>% 
    group_by(work_tools)  %>% 
    summarise(count = n())  %>% 
    arrange(desc(count))

# Print the first 6 results
head(tool_count)



# Create a bar chart of the work_tools column, most counts on the far right
ggplot(tool_count, aes(x = fct_reorder(work_tools, count), y = count)) + 
    geom_bar(stat = "identity") +
    theme(axis.text.x  = element_text(angle=90, vjust=0.5, hjust= 1))


# Create a new column called language preference
debate_tools <- responses  %>% 
    mutate(language_preference = case_when(
        str_detect(WorkToolsSelect, "R") & ! str_detect(WorkToolsSelect, "Python") ~ "R",
        str_detect(WorkToolsSelect, "Python") & ! str_detect(WorkToolsSelect, "R") ~ "Python",
        str_detect(WorkToolsSelect, "R") & str_detect(WorkToolsSelect, "Python")   ~ "both",
        TRUE ~ "neither"
    ))


# Print the first 6 rows
head(debate_tools)


# Group by language preference, calculate number of responses, and remove "neither"
debate_plot <- debate_tools %>% 
    group_by(language_preference)  %>%
    summarise(count = n())  %>% 
    filter(!language_preference == "neither")

# Creating a bar chart
ggplot(debate_plot, aes(x = language_preference, y = count)) + 
  geom_bar(stat = "identity")


# Group by, summarise, arrange, mutate, and filter
recommendations <- debate_tools  %>% 
    group_by(language_preference, LanguageRecommendationSelect)  %>%
    summarise(count = n())  %>% 
    arrange(language_preference, desc(count))  %>% 
    mutate(row = row_number()) %>% 
    filter(row <= 4)


# Create a faceted bar plot
ggplot(recommendations, aes(x = LanguageRecommendationSelect, y = count)) +
    geom_bar(stat = "identity") + 
    facet_wrap(~language_preference)


# Would R users find this statement TRUE or FALSE?
R_is_number_one = TRUE
