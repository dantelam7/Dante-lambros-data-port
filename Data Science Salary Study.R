df <- read.csv("C:/Users/bclam/OneDrive/Documents/Data Scientist Salary_2021.csv")
# Check the first few rows
head(df)

# Get the column names
colnames(df)

# Create the State variable from Job.Location
df$State <- substr(df$Job.Location, nchar(df$Job.Location) - 1, nchar(df$Job.Location))

# Drop rows with any missing values in selected columns
model_data <- df[!is.na(df$Salary) &
                   !is.na(df$number.of.employee) &
                   !is.na(df$Python) &
                   !is.na(df$sql) &
                   !is.na(df$excel) &
                   !is.na(df$Sector) &
                   !is.na(df$State), 
                 c("Salary", "State", "number.of.employee", "Python", "sql", "excel", "Sector")]
# Convert Sector and State to factor variables
model_data$Sector <- as.factor(model_data$Sector)
model_data$State <- as.factor(model_data$State)
# Run multivariate linear regression
model1 <- lm(Salary ~ State + number.of.employee + Python + sql + excel + Sector, data = model_data)

# View summary
summary(model1)

# Model 2: Fixed Effects Regression using State
model2 <- lm(Salary ~ number.of.employee + Python + sql + excel + Sector + State, data = model_data)

# View the summary
summary(model2)

# Add log of salary column
model_data$log_salary <- log(model_data$Salary)
# Model 3: Logarithmic Regression
model3 <- lm(log_salary ~ number.of.employee + Python + sql + excel + Sector + State, data = model_data)

# View the results
summary(model3)

# Add a squared term for company size
model_data$company_size_sq <- model_data$number.of.employee^2

# Model 4: Polynomial Regression with squared company size
model4 <- lm(log_salary ~ number.of.employee + company_size_sq + Python + sql + excel + Sector + State, data = model_data)

# View the summary
summary(model4)
#visual exploration + model 5
median_salary <- median(model_data$Salary, na.rm = TRUE)
print(median_salary)

model_data$above_median <- ifelse(model_data$Salary > 96250, 1, 0)

logit_model <- glm(above_median ~ number.of.employee + Python + sql + excel + Sector + State,
                   data = model_data,
                   family = binomial)

summary(logit_model)

#visual summaries

# Load necessary library
library(ggplot2)
library(broom)

# Tidy the model results
model_tidy <- tidy(logit_model)  # Replace with your model variable

# Remove intercept if you don’t want it in the plot
model_tidy <- subset(model_tidy, term != "(Intercept)")

# Create the plot
ggplot(model_tidy, aes(x = estimate, y = reorder(term, estimate))) +
  geom_point() +
  geom_errorbarh(aes(xmin = estimate - std.error, xmax = estimate + std.error), height = 0.2) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  labs(
    title = "Logistic Regression Coefficients",
    x = "Log-Odds Estimate",
    y = "Predictor"
  ) +
  theme_minimal(base_size = 12)
# Load necessary library
library(ggplot2)

# Get predicted probabilities from the model
model_data$predicted_prob <- predict(logit_model, type = "response")

# Plot predicted probability by Python skill
ggplot(model_data, aes(x = factor(Python), y = predicted_prob)) +
  geom_boxplot(fill = "skyblue") +
  labs(title = "Predicted Probability of Salary > Median by Python Skill",
       x = "Knows Python (0 = No, 1 = Yes)",
       y = "Predicted Probability") +
  theme_minimal()

class(data)

# Load required package
library(pROC)

# Predict probabilities using logistic model
predicted_probs <- predict(logit_model, newdata = model_data, type = "response")

# Generate ROC object
roc_obj <- roc(model_data$above_median ~ predicted_probs)

# Plot ROC curve with improvements
plot(
  roc_obj,
  col = "blue",
  lwd = 2,
  main = "ROC Curve: Logistic Regression (Model 5)",
  xlim = c(0, 1),
  ylim = c(0, 1),
  legacy.axes = TRUE
)

# Add AUC text on the plot
auc_value <- auc(roc_obj)
text(0.6, 0.2, paste("AUC =", round(auc_value, 3)), cex = 1.2)

# Create binary predictions using 0.5 cutoff
predicted_class <- ifelse(predicted_probs >= 0.5, 1, 0)

# Generate the confusion matrix
conf_matrix <- table(Predicted = predicted_class, Actual = model_data$above_median)

# Print the confusion matrix
print(conf_matrix)

# Optional: Calculate accuracy
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)
cat("Accuracy:", round(accuracy, 3), "\n")


























