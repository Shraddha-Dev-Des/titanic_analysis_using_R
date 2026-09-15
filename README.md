# Week 1 – Data Cleaning and Preliminary Analysis with R

## 📊 Project Overview

This project focuses on **data cleaning, preprocessing, and preliminary exploratory data analysis using R**.

For this analysis, the **Titanic – Machine Learning from Disaster** dataset was selected. The dataset contains both numerical and categorical variables and includes missing values, making it suitable for practicing real-world data-cleaning techniques.

The project demonstrates how raw data can be inspected, cleaned, transformed, analyzed, and prepared for further statistical or machine-learning analysis.

---

## 🎯 Objectives

The main objectives of this project are:

- Understand and inspect a real-world dataset.
- Identify missing values and handle them appropriately.
- Detect potential outliers using the IQR method.
- Perform data transformation and feature engineering.
- Standardize numerical variables.
- Encode categorical variables.
- Generate descriptive statistics.
- Perform correlation analysis.
- Create exploratory visualizations.
- Document the complete analysis using R.

---

## 📁 Dataset

### Dataset Name
**Titanic – Machine Learning from Disaster**

### Dataset Description

The dataset contains information about passengers who travelled on the RMS Titanic.

It includes variables such as:

| Variable | Description |
|---|---|
| PassengerId | Unique passenger identifier |
| Survived | Survival status (0 = No, 1 = Yes) |
| Pclass | Passenger class |
| Name | Passenger name |
| Sex | Passenger gender |
| Age | Passenger age |
| SibSp | Number of siblings/spouses aboard |
| Parch | Number of parents/children aboard |
| Ticket | Ticket number |
| Fare | Passenger fare |
| Cabin | Cabin number |
| Embarked | Port of embarkation |

### Dataset Size

- **Rows:** 891
- **Columns:** 12

### Dataset Source

The dataset is from the Kaggle Titanic competition:

https://www.kaggle.com/competitions/titanic/overview

---

# 🧹 Data Cleaning Process

## 1. Initial Data Inspection

The following R functions were used to understand the structure and characteristics of the dataset:

```r
str(titanic)
summary(titanic)
dim(titanic)
```

These functions help identify:

- Number of observations
- Number of variables
- Data types
- Minimum and maximum values
- Mean and median values
- Potential missing values

---

## 2. Missing Value Analysis

Missing values were identified using:

```r
missing_summary <- data.frame(
  variable = names(titanic),
  missing_count = sapply(titanic, function(x) sum(is.na(x))),
  missing_percent = round(
    sapply(titanic, function(x) mean(is.na(x)) * 100), 2
  )
)

missing_summary
```

Important missing-value observations:

- **Age:** 177 missing values
- **Cabin:** 687 missing values
- **Embarked:** 2 missing values

---

## 3. Handling Missing Values

### Age

The missing Age values were replaced using the median:

```r
age_median <- median(titanic$age, na.rm = TRUE)

titanic$age[is.na(titanic$age)] <- age_median
```

Median imputation was selected because it is less affected by extreme values than the mean.

### Embarked

The missing Embarked values were replaced with the mode:

```r
mode_embarked <- names(
  sort(table(titanic$embarked), decreasing = TRUE)
)[1]

titanic$embarked[
  is.na(titanic$embarked)
] <- mode_embarked
```

### Cabin

The Cabin variable contained a very high percentage of missing values, so it was removed for this preliminary analysis:

```r
titanic$cabin <- NULL
```

---

# 🔧 Feature Engineering

Two additional variables were created.

## Family Size

Family size was calculated using:

```r
family_size = sib_sp + parch + 1
```

The `+1` represents the passenger themselves.

## Is Alone

A new categorical variable was created:

```r
is_alone = if_else(family_size == 1, "Yes", "No")
```

This identifies whether a passenger was travelling alone.

---

# 🚨 Outlier Detection

Outliers were detected using the **Interquartile Range (IQR) method**.

The formula used is:

```text
Lower Bound = Q1 - 1.5 × IQR
Upper Bound = Q3 + 1.5 × IQR
```

Example for Fare:

```r
fare_q1 <- quantile(titanic$fare, 0.25)
fare_q3 <- quantile(titanic$fare, 0.75)

fare_iqr <- fare_q3 - fare_q1

fare_low <- fare_q1 - 1.5 * fare_iqr
fare_high <- fare_q3 + 1.5 * fare_iqr
```

The detected Fare outliers were **not automatically deleted**, because high fares may represent genuine first-class passengers rather than incorrect data.

---

# 📏 Normalization / Standardization

Age and Fare were standardized using z-score standardization.

```r
titanic <- titanic %>%
  mutate(
    age_z = as.numeric(scale(age)),
    fare_z = as.numeric(scale(fare))
  )
```

Standardization places numerical variables on a comparable scale and can be useful for later machine-learning algorithms.

---

# 🔤 Categorical Encoding

Categorical variables were converted into factors:

```r
titanic$sex <- factor(titanic$sex)
titanic$embarked <- factor(titanic$embarked)
titanic$is_alone <- factor(titanic$is_alone)
```

Dummy/indicator variables were then generated using:

```r
encoded_data <- model.matrix(
  ~ sex + embarked + is_alone + pclass - 1,
  data = titanic
)

encoded_data <- as.data.frame(encoded_data)
```

This converts categorical information into numerical variables suitable for statistical and machine-learning models.

---

# 📈 Exploratory Data Analysis

Several exploratory analyses were performed.

## Survival Distribution

The overall number of passengers who survived and did not survive was examined.

```r
ggplot(titanic, aes(x = survived)) +
  geom_bar() +
  labs(
    title = "Titanic Survival Distribution",
    x = "Survived",
    y = "Number of Passengers"
  )
```

## Survival by Sex

Survival proportions were compared between male and female passengers.

```r
ggplot(titanic, aes(x = sex, fill = survived)) +
  geom_bar(position = "fill")
```

## Survival by Passenger Class

Survival proportions were also compared across passenger classes.

```r
ggplot(titanic, aes(x = pclass, fill = survived)) +
  geom_bar(position = "fill")
```

## Age Distribution

The distribution of passenger ages was visualized using a histogram.

```r
ggplot(titanic, aes(x = age)) +
  geom_histogram(bins = 20)
```

## Fare Outlier Detection

A boxplot was used to identify potential Fare outliers.

```r
ggplot(titanic, aes(y = fare)) +
  geom_boxplot()
```

---

# 🔗 Correlation Analysis

Correlation between selected numerical variables was calculated using:

```r
numeric_data <- titanic %>%
  transmute(
    survived_numeric = as.numeric(survived) - 1,
    pclass_numeric = as.numeric(as.character(pclass)),
    age,
    sib_sp,
    parch,
    fare
  )

cor(numeric_data, use = "complete.obs")
```

Correlation analysis helps identify relationships between numerical variables.

**Important:** Correlation indicates association and does not prove causation.

---

# 💡 Initial Findings

The preliminary analysis produced several observations:

1. The Titanic dataset contains substantial missing information in the Cabin variable.
2. Age contains a moderate number of missing observations and was treated using median imputation.
3. Embarked has only a small number of missing observations and was treated using mode imputation.
4. Fare contains several observations identified as IQR-based outliers.
5. Female passengers had a substantially higher survival rate than male passengers.
6. First-class passengers had a higher survival rate than second- and third-class passengers.
7. Fare and passenger survival show a positive association.
8. Passenger class and survival show a negative association when passenger class is represented numerically.
9. Standardized Age and Fare variables were created for possible future modeling.
10. The cleaned dataset is suitable for further exploratory analysis and predictive modeling.

---

# 🗂️ Project Files

The repository contains the following files:

```text
Week-1-Data-Cleaning-R/
│
├── README.md
├── week1_titanic_analysis.R
├── titanic_train.csv
└── titanic_cleaned_encoded.csv
```

### File Descriptions

**`README.md`**

This document describing the project, methodology, and results.

**`week1_titanic_analysis.R`**

Complete R script containing data import, cleaning, transformation, visualization, correlation analysis, and data export.

**`titanic_train.csv`**

Original Titanic training dataset.

**`titanic_cleaned_encoded.csv`**

Processed dataset after cleaning, feature engineering, standardization, and categorical encoding.

---

# 🛠️ Technologies Used

- **R**
- **RStudio**
- **Tidyverse**
- **ggplot2**
- **Janitor**
- **Scales**

---

# ▶️ How to Run the Project

### Step 1: Install R

Download and install R from:

https://cran.r-project.org/

### Step 2: Install RStudio

RStudio can be downloaded from:

https://posit.co/download/rstudio-desktop/

### Step 3: Clone or Download this Repository

Download all project files and place them in the same folder.

### Step 4: Open the R Script

Open:

```text
week1_titanic_analysis.R
```

in RStudio.

### Step 5: Install Required Packages

Run:

```r
install.packages("tidyverse")
install.packages("janitor")
install.packages("scales")
```

### Step 6: Run the Script

Execute the R code section by section or run the complete script.

The script will:

- Import the dataset
- Inspect the data
- Identify missing values
- Clean the dataset
- Detect outliers
- Create new variables
- Standardize numerical variables
- Encode categorical variables
- Perform exploratory analysis
- Generate visualizations
- Export processed datasets

---

# 📊 Expected Outcomes

After running the project, the user should obtain:

- Cleaned Titanic dataset
- Encoded categorical variables
- Standardized numerical variables
- Missing-value summary
- Outlier analysis
- Descriptive statistics
- Correlation matrix
- Exploratory visualizations
- Initial insights into passenger survival

---

# 📌 Conclusion

This project demonstrates a complete introductory data-analysis workflow using R.

The Titanic dataset was inspected and cleaned using appropriate techniques for missing values and outliers. Additional features were created, numerical variables were standardized, and categorical variables were encoded.

Exploratory analysis revealed clear descriptive differences in survival across passenger sex and passenger class. The processed dataset can be used as a foundation for future predictive modeling and advanced statistical analysis.

---

## 👤 Author

**Student Name:** ______________________________

**Course / Program:** ___________________________

**College:** ___________________________________

**Roll No.:** __________________________________

**Academic Year:** 2026–2027

---

## 📚 References

1. Kaggle – Titanic: Machine Learning from Disaster  
   https://www.kaggle.com/competitions/titanic/overview

2. R Project for Statistical Computing  
   https://www.r-project.org/

3. Posit – RStudio  
   https://posit.co/products/open-source/rstudio/