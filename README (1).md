# Week 2 – Data Visualization and Insight Communication using R

## Project Overview
This project focuses on data visualization and insight communication using R. The Titanic dataset from Week 1 is continued to demonstrate a complete and consistent data-analysis workflow.

**Terminology note:** The project uses **Gender** instead of **Sex** throughout the report, R code, visualizations, and documentation.

## Objectives
- Create informative visualizations using R and ggplot2.
- Use different chart types for comparisons, distributions, relationships, trends, and multi-category analysis.
- Explain why each chart was selected.
- Communicate findings clearly to a non-technical audience.
- Document reproducible R code and visual outputs.

## Dataset
**Titanic – Machine Learning from Disaster**  
Rows: 891  
Original variables: 12  
Source: https://www.kaggle.com/competitions/titanic/overview

Missing Age values were handled using the median and missing Embarked values using the mode. FamilySize and AgeGroup were prepared for visualization.

## Visualizations
1. Survival Rate by Passenger Class – Bar Chart
2. Survival Proportion by Gender – Proportional Stacked Bar Chart
3. Passenger Age Distribution – Histogram
4. Fare Distribution by Passenger Class – Box Plot
5. Age vs Fare by Survival Status – Scatter Plot
6. Survival Rate Across Age Groups – Line Chart
7. Age Distribution by Gender – Comparative Histogram
8. Survival Rate by Gender and Passenger Class – Heatmap

## Key Insights
- First-class passengers had a substantially higher survival rate than third-class passengers.
- Female passengers had a substantially higher survival rate than male passengers.
- Passenger ages are concentrated mainly in adult age ranges.
- Fare distributions differ strongly across passenger classes, with high-fare observations visible at the upper end.
- Age and fare do not show a simple one-to-one relationship.
- Survival rates vary across age groups, although small groups should be interpreted cautiously.
- Combining gender and passenger class provides a more detailed view of survival patterns.

## Tools and Libraries
- R
- RStudio
- ggplot2
- dplyr
- janitor
- scales

## Repository Structure
```text
Week-2-Data-Visualization-R/
│
├── README.md
├── week2_titanic_visualization_gender.R
├── titanic_visualization_gender_data.csv
├── age_group_survival_summary.csv
├── survival_heatmap_gender_class_summary.csv
│
├── 01_survival_by_class_bar.png
├── 02_survival_by_gender_proportion.png
├── 03_age_histogram.png
├── 04_fare_boxplot_class.png
├── 05_age_vs_fare_scatter.png
├── 06_survival_by_age_group_line.png
├── 07_age_distribution_by_gender.png
└── 08_survival_heatmap_gender_class.png
```

## How to Run
Install the required packages:
```r
install.packages("tidyverse")
install.packages("janitor")
install.packages("scales")
```

Open `week2_titanic_visualization_gender.R` in RStudio and run the script.

## Conclusion
The project demonstrates how appropriate visualization choices can turn cleaned passenger data into an understandable analytical story. It combines technical R skills with clear communication of patterns and insights.

## Author
**Student Name:** ______________________________  
**Course / Program:** ___________________________  
**College:** ___________________________________  
**Roll No.:** __________________________________  
**Academic Year:** 2026–2027

## References
- Kaggle Titanic: https://www.kaggle.com/competitions/titanic/overview
- R Project: https://www.r-project.org/
- Posit RStudio: https://posit.co/products/open-source/rstudio/
