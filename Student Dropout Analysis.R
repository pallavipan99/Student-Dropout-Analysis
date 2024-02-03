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