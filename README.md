# Data Scientist Salary Modeling (MSIS 642 Project)

## Overview
This project explores what factors influence a data scientist’s salary using real-world job data. I built five regression models in R to understand both salary levels and the probability of earning above the median salary.

## Tools Used
- R
- `ggplot2`, `broom`, `pROC`
- Logistic Regression, Linear Regression, Polynomial Regression

##  Models Built
1. **Linear Regression**  R² = 0.3672  
2. **Fixed Effects Regression (State)** – Controlled for location  
3. **Log Regression** R² = 0.3803  
4. **Polynomial Regression**  R² = 0.3816  
5. **Logistic Regression**  AUC = 0.808, Accuracy = 73.8%

##  Key Insights
- Knowing **Python** was the strongest predictor of higher salary (**~23% increase**)  
- **Excel** and **SQL** were both **negatively associated** with salary  
- Data roles in **California** offered **~75% higher** salaries than baseline states  
- Logistic regression classified salary level (above/below median) with **73.8% accuracy**

##  Files
- `salary_model.R` – R script with full modeling workflow
- **`642_Report_Dante_Lambros.pdf` This is my full write-up with visuals and interpretation for the clearest explanations**
- `Data Scientist Salary_2021.csv` 
