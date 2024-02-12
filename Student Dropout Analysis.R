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