# Week 2: Data Visualization and Insight Communication using R
# Dataset: Titanic – Machine Learning from Disaster
# Note: "gender" is used instead of "sex" throughout this project.

library(tidyverse)
library(janitor)
library(scales)

titanic <- read.csv("titanic_visualization_gender_data.csv",
                    stringsAsFactors = FALSE) |> clean_names()

# Rename sex to gender if the source dataset contains sex
if ("sex" %in% names(titanic)) {
  titanic <- titanic |> rename(gender = sex)
}

str(titanic)
summary(titanic)
dim(titanic)

titanic <- titanic |> mutate(
  pclass = factor(pclass, levels = c(1,2,3),
                  labels = c("1st Class","2nd Class","3rd Class")),
  survived = factor(survived, levels = c(0,1),
                    labels = c("Did not survive","Survived")),
  gender = factor(gender),
  age_group = cut(age,
                  breaks = c(0,10,20,30,40,50,60,70,100),
                  labels = c("0-10","11-20","21-30","31-40",
                             "41-50","51-60","61-70","71+"),
                  include.lowest = TRUE)
)

# 1. Bar chart – Survival Rate by Passenger Class
ggplot(titanic, aes(x = pclass,
                     y = as.numeric(survived == "Survived"))) +
  stat_summary(fun = mean, geom = "col") +
  scale_y_continuous(labels = percent) +
  labs(title = "Survival Rate by Passenger Class",
       x = "Passenger Class", y = "Survival Rate")

# 2. Proportional bar – Survival by Gender
ggplot(titanic, aes(x = gender, fill = survived)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = percent) +
  labs(title = "Survival Proportion by Gender",
       x = "Gender", y = "Proportion")

# 3. Histogram – Age Distribution
ggplot(titanic, aes(x = age)) +
  geom_histogram(bins = 20, color = "black") +
  labs(title = "Passenger Age Distribution",
       x = "Age (years)", y = "Number of Passengers")

# 4. Boxplot – Fare by Class
ggplot(titanic, aes(x = pclass, y = fare)) +
  geom_boxplot() +
  labs(title = "Fare Distribution by Passenger Class",
       x = "Passenger Class", y = "Fare")

# 5. Scatter plot – Age vs Fare
ggplot(titanic, aes(x = age, y = fare, shape = survived)) +
  geom_point(alpha = 0.5) +
  labs(title = "Age vs Fare by Survival Status",
       x = "Age (years)", y = "Fare", shape = "Outcome")

# 6. Line chart – Survival by Age Group
age_summary <- titanic |>
  group_by(age_group) |>
  summarise(
    survival_rate = mean(survived == "Survived"),
    passengers = n(),
    .groups = "drop"
  )

ggplot(age_summary, aes(x = age_group, y = survival_rate, group = 1)) +
  geom_line() +
  geom_point(size = 2) +
  scale_y_continuous(labels = percent) +
  labs(title = "Survival Rate Across Age Groups",
       x = "Age Group", y = "Survival Rate")

# 7. Comparative histogram – Age by Gender
ggplot(titanic, aes(x = age, fill = gender)) +
  geom_histogram(bins = 18, alpha = 0.6,
                 position = "identity") +
  labs(title = "Age Distribution by Gender",
       x = "Age (years)", y = "Number of Passengers")

# 8. Heatmap – Gender and Passenger Class
survival_heatmap <- titanic |>
  group_by(gender, pclass) |>
  summarise(
    survival_rate = mean(survived == "Survived"),
    .groups = "drop"
  )

ggplot(survival_heatmap,
       aes(x = pclass, y = gender, fill = survival_rate)) +
  geom_tile() +
  geom_text(aes(label =
                  percent(survival_rate, accuracy = 0.1))) +
  scale_fill_continuous(labels = percent) +
  labs(title = "Survival Rate by Gender and Passenger Class",
       x = "Passenger Class", y = "Gender",
       fill = "Survival Rate")

# Supporting summaries
titanic |>
  group_by(gender) |>
  summarise(
    survival_rate = mean(survived == "Survived"),
    passengers = n(),
    .groups = "drop"
  )

titanic |>
  group_by(pclass) |>
  summarise(
    survival_rate = mean(survived == "Survived"),
    passengers = n(),
    .groups = "drop"
  )

# Correlation matrix
numeric_data <- titanic |>
  transmute(
    survived_numeric = as.numeric(survived == "Survived"),
    pclass_numeric = as.numeric(pclass),
    age, sib_sp, parch, fare, family_size
  )

cor(numeric_data, use = "complete.obs")

write.csv(age_summary, "age_group_survival_summary.csv",
          row.names = FALSE)
write.csv(survival_heatmap, "survival_heatmap_gender_class_summary.csv",
          row.names = FALSE)
