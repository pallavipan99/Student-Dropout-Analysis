# Install and load devtools
install.packages("devtools")
library(devtools)

# Install the HypothesisTesting package from GitHub
devtools::install_github("janish-parikh/ZTest")

# Load the HypothesisTesting library
library(HypothesisTesting)

getwd()
one<-read.csv('student_dropout.csv') # dataset is chosen from Kaggle
head(one)

# Pattern 1
dropout_by_parent_education <- tapply(one$Dropped_Out, list(one$Mother_Education, one$Father_Education), mean)
print(dropout_by_parent_education)
barplot(dropout_by_parent_education, 
        main = "Dropout Rates by Mother's and Father's Education", 
        xlab = "Father's Education Level", 
        ylab = "Dropout Rate", 
        beside = TRUE, 
        legend = rownames(dropout_by_parent_education), 
        col = c("lightblue", "lightgreen", "lightcoral", "lightyellow", "lightpink"),
        args.legend = list(title = "Mother's Education Level"))

# Pattern 2
dropout_by_absences <- tapply(one$Dropped_Out, one$Number_of_Absences, mean)
print(dropout_by_absences)
barplot(dropout_by_absences, 
        main = "Dropout Rates by Number of Absences", 
        xlab = "Number of Absences", 
        ylab = "Dropout Rate", 
        col = "red", 
        border = "black")

# Pattern 3
dropout_by_school_reason <- tapply(one$Dropped_Out, one$Reason_for_Choosing_School, mean)
print(dropout_by_school_reason)
barplot(dropout_by_school_reason, 
        main = "Dropout Rates by Reason for Choosing School", 
        xlab = "Reason for Choosing School", 
        ylab = "Dropout Rate", 
        col = "red", 
        border = "black")

# Query 1: Number of students who dropped out by school
school_dropout_table<-table(one$School, one$Dropped_Out)
barplot(school_dropout_table, main="Number of Students Who Dropped Out by School",
        xlab="School", ylab="Number of Students", col=c("lightblue", "lightgreen"),
        beside=TRUE, legend = rownames(school_dropout_table))

# Query 2: Gender distribution of dropout students
gender_dropout_table<-table(one$Gender, one$Dropped_Out)

# Query 3: Dropout rates based on parental education
tapply(one$Dropped_Out, list(one$Mother_Education, one$Father_Education), mean)

# Query 4: Alcohol consumption by gender
alcohol_consumption_by_gender<-tapply(one$Weekend_Alcohol_Consumption, one$Gender, mean)
barplot(alcohol_consumption_by_gender, 
        main = "Average Weekend Alcohol Consumption by Gender", 
        xlab = "Gender", 
        ylab = "Average Alcohol Consumption (units)", 
        col = "red", 
        border = "black")

# Query 5: Subset of students with high family relationships
high_family_relationship <- subset(one, Family_Relationship > 4)
print(high_family_relationship)

# Query 6: Students who dropped out and their alcohol consumption patterns
dropouts_vs_alcohol <- subset(one, Dropped_Out == TRUE)
tapply(dropouts_vs_alcohol$Weekend_Alcohol_Consumption, dropouts_vs_alcohol$Gender, mean)

# Query 7: Study time and its impact on final grades
tapply(one$Final_Grade, one$Study_Time, mean)
boxplot(one$Final_Grade ~ one$Study_Time,
        main = "Study Time vs Final Grades",
        xlab = "Study Time (hours per week)",
        ylab = "Final Grade",
        col = "lightblue",
        border = "black")

# Query 8: Relationship between family support and dropout rate
tapply(one$Dropped_Out, one$Family_Support, mean)

# Query 9: Grades based on students' free time
tapply(one$Final_Grade, one$Free_Time, mean)

# Query 10: Subset of students who have both school support and family support
supportive_students <- subset(one, School_Support == 'yes' & Family_Support == 'yes')
print(supportive_students)

# Hypothesis 1: Strong Hypothesis
cat("Significance Level: 0.01\n")
# Family Support vs Dropout Rates - Filter for students with low grades (<10) and high absences (>15)
subset_data <- subset(one, Final_Grade < 10 & Number_of_Absences > 15 & (Mother_Education >= 3 | Father_Education >= 3))
# Create Family Support Group
subset_data$Family_Support_Group <- ifelse(subset_data$Family_Support == "yes", "With Support", "Without Support")
# Calculate dropout rates using tapply
dropout_rates_hypothesis_1 <- tapply(subset_data$Dropped_Out, subset_data$Family_Support_Group, mean)
# Perform the permutation test 
p_value_1 <- permutation_test(subset_data, "Family_Support_Group", "Dropped_Out", 100000, "With Support", "Without Support")
# Print the result
cat("P-value for Hypothesis 1 (Family Support vs Dropout):", p_value_1, "\n")

#Hypothesis 2: Close Call Hypothesis
cat("Significance Level: 0.05\n")
# Create Absence Group based on existing data
one$Absence_Group <- ifelse(one$Number_of_Absences > 10, "High Absences", "Low Absences")
# Check the distribution of Absence Groups
cat("Counts in Absence Groups:\n")
print(table(one$Absence_Group))
# Calculate dropout rates using tapply
dropout_rates_hypothesis_2 <- tapply(one$Dropped_Out, one$Absence_Group, mean)
# Perform the permutation test comparing Low Absences vs High Absences
p_value_2 <- permutation_test(one, "Absence_Group", "Dropped_Out", 10000, "Low Absences", "High Absences")
cat("P-value for Hypothesis 2 (Low vs High Absences):", p_value_2, "\n")


# Hypothesis 3: Failed to Reject Null Hypothesis
cat("Significance Level: 0.05\n")
# Alternative Hypothesis (H1): Different reasons for choosing a school affect dropout rates
reason_a <- "course"      # First valid category
reason_b <- "reputation"  # Second valid category
# Perform z-test for the chosen reasons for choosing school
p_value_3 <- z_test_from_data(one, "Reason_for_Choosing_School", "Dropped_Out", reason_a, reason_b)
# Print the p-value for Hypothesis 3
cat("P-value for Hypothesis 3 (Reason for Choosing School vs Dropout):", p_value_3, "\n")

# Narrow Query
# Calculate M: mean of Number_of_Absences for the subset
M_absences <- mean(subset_data$Number_of_Absences)
# Calculate M0: mean of Number_of_Absences for the entire dataset
M0_absences <- mean(one$Number_of_Absences)
subset_data <- subset(one, Family_Support == 'no' & Number_of_Absences > 20)
# Check if M > 2 * M0 or M < 0.5 * M0
cat("M0:", M0_absences, "\nM:", M_absences, "\n")
cat("Condition 1 (M > 2 * M0):", M_absences > 2 * M0_absences, "\n")
cat("Condition 2 (M < 0.5 * M0):", M_absences < 0.5 * M0_absences, "\n")