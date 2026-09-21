# Week 1: Data Cleaning and Preliminary Analysis with R
# Dataset: Titanic train.csv (891 rows, 12 columns)
# Source: Kaggle Titanic competition / public mirror
# Required packages: tidyverse, janitor, scales

library(tidyverse)
library(janitor)
library(scales)

# 1. Import data
titanic <- read.csv("titanic_train.csv", stringsAsFactors = FALSE)
titanic <- clean_names(titanic)

# 2. Inspect structure and summary
str(titanic)
summary(titanic)
dim(titanic)

# 3. Missing-value audit
missing_summary <- data.frame(
  variable = names(titanic),
  missing_count = sapply(titanic, function(x) sum(is.na(x))),
  missing_percent = round(sapply(titanic, function(x) mean(is.na(x))*100), 2)
)
missing_summary

# 4. Data cleaning
# Age: median imputation because Age is numeric and contains 177 missing values
age_median <- median(titanic$age, na.rm = TRUE)
titanic$age[is.na(titanic$age)] <- age_median

# Embarked: mode imputation because only two values are missing
mode_embarked <- names(sort(table(titanic$embarked), decreasing = TRUE))[1]
titanic$embarked[is.na(titanic$embarked)] <- mode_embarked

# Cabin has 687 missing values (77.10%); remove it for this preliminary analysis
titanic$cabin <- NULL

# 5. Feature transformation
titanic <- titanic %>%
  mutate(
    family_size = sib_sp + parch + 1,
    is_alone = if_else(family_size == 1, "Yes", "No"),
    sex = factor(sex),
    embarked = factor(embarked),
    pclass = factor(pclass),
    survived = factor(survived, levels = c(0,1),
                      labels = c("No","Yes"))
  )

# 6. Outlier detection using IQR
fare_q1 <- quantile(titanic$fare, 0.25)
fare_q3 <- quantile(titanic$fare, 0.75)
fare_iqr <- fare_q3 - fare_q1
fare_low <- fare_q1 - 1.5 * fare_iqr
fare_high <- fare_q3 + 1.5 * fare_iqr

fare_outliers <- titanic %>%
  filter(fare < fare_low | fare > fare_high)
nrow(fare_outliers)

age_q1 <- quantile(titanic$age, 0.25)
age_q3 <- quantile(titanic$age, 0.75)
age_iqr <- age_q3 - age_q1
age_low <- age_q1 - 1.5 * age_iqr
age_high <- age_q3 + 1.5 * age_iqr
age_outliers <- titanic %>%
  filter(age < age_low | age > age_high)
nrow(age_outliers)

# 7. Normalization / standardization
titanic <- titanic %>%
  mutate(
    age_z = as.numeric(scale(age)),
    fare_z = as.numeric(scale(fare))
  )

# 8. Categorical encoding
# model.matrix creates dummy/indicator variables
encoded_data <- model.matrix(~ sex + embarked + is_alone + pclass - 1, data = titanic)
encoded_data <- as.data.frame(encoded_data)

# 9. Exploratory analysis
summary(titanic)
table(titanic$sex, titanic$survived)
prop.table(table(titanic$sex, titanic$survived), 1)

table(titanic$pclass, titanic$survived)
prop.table(table(titanic$pclass, titanic$survived), 1)

# 10. Correlation of numerical variables
numeric_data <- titanic %>%
  transmute(
    survived_numeric = as.numeric(survived) - 1,
    pclass_numeric = as.numeric(as.character(pclass)),
    age, sib_sp, parch, fare
  )
cor(numeric_data, use = "complete.obs")

# 11. Visualizations
ggplot(titanic, aes(x = survived)) +
  geom_bar() +
  labs(title = "Titanic Survival Distribution",
       x = "Survived", y = "Number of Passengers")

ggplot(titanic, aes(x = sex, fill = survived)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = percent) +
  labs(title = "Survival Proportion by Sex",
       x = "Sex", y = "Proportion")

ggplot(titanic, aes(x = pclass, fill = survived)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = percent) +
  labs(title = "Survival Proportion by Passenger Class",
       x = "Passenger Class", y = "Proportion")

ggplot(titanic, aes(x = age)) +
  geom_histogram(bins = 20, color = "black") +
  labs(title = "Age Distribution After Imputation",
       x = "Age", y = "Frequency")

ggplot(titanic, aes(y = fare)) +
  geom_boxplot() +
  labs(title = "Fare Outlier Detection",
       y = "Fare")

# 12. Export cleaned data
write.csv(titanic, "titanic_cleaned.csv", row.names = FALSE)
write.csv(encoded_data, "titanic_encoded_variables.csv", row.names = FALSE)
