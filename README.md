# Student Dropout Analysis

This R project performs an **exploratory data analysis (EDA)** and hypothesis testing on a student dropout dataset (`student_dropout.csv`). The analysis includes visualization, querying patterns, and statistical tests using permutation and z-tests.

---

## **Project Overview**

The goal of this project is to analyze patterns in student dropout data, explore factors affecting dropout rates, and test hypotheses using statistical methods.

Key tasks include:

- Exploring dropout rates based on parental education, absences, and reasons for choosing school.
- Visualizing dropout distributions across schools and genders.
- Examining relationships between family support, study time, alcohol consumption, and grades.
- Performing hypothesis testing with permutation tests and z-tests.

---

## **Dataset**

- **File:** `student_dropout.csv`
- **Source:** Kaggle (Student Dropout Dataset)
- **Description:** The dataset contains variables such as:

| Variable                      | Description                                 |
| ----------------------------- | ------------------------------------------- |
| `Dropped_Out`                 | Binary indicator if the student dropped out |
| `Mother_Education`            | Mother’s education level (categorical)      |
| `Father_Education`            | Father’s education level (categorical)      |
| `Number_of_Absences`          | Total absences of the student               |
| `Reason_for_Choosing_School`  | Reason student chose the school             |
| `School`                      | School name                                 |
| `Gender`                      | Gender of the student                       |
| `Weekend_Alcohol_Consumption` | Alcohol consumption on weekends             |
| `Family_Relationship`         | Quality of family relationship              |
| `Study_Time`                  | Hours spent studying per week               |
| `Final_Grade`                 | Final grade                                 |
| `Family_Support`              | Binary indicator of family support          |
| `School_Support`              | Binary indicator of school support          |
| `Free_Time`                   | Amount of free time                         |

---

## **Dependencies**

- **R packages:**

```r
install.packages("devtools")
library(devtools)
devtools::install_github("janish-parikh/ZTest")
library(HypothesisTesting)
```

- **Other packages:** `graphics`, `stats` (usually pre-installed with R)

---

## **Analysis Steps**

### 1. Load Dataset

```r
one <- read.csv('student_dropout.csv')
head(one)
```

### 2. Exploratory Analysis

- **Dropout rates by parental education:**

```r
dropout_by_parent_education <- tapply(one$Dropped_Out, list(one$Mother_Education, one$Father_Education), mean)
barplot(dropout_by_parent_education)
```

- **Dropout rates by absences, school reason, and school:**

```r
dropout_by_absences <- tapply(one$Dropped_Out, one$Number_of_Absences, mean)
barplot(dropout_by_absences)
```

- **Gender distribution of dropouts**

```r
gender_dropout_table <- table(one$Gender, one$Dropped_Out)
```

- **Alcohol consumption, study time, family support:**

```r
tapply(one$Final_Grade, one$Study_Time, mean)
tapply(one$Dropped_Out, one$Family_Support, mean)
```

---

### 3. Hypothesis Testing

1. **Family Support vs Dropout (Strong Hypothesis)**

```r
p_value_1 <- permutation_test(subset_data, "Family_Support_Group", "Dropped_Out", 100000, "With Support", "Without Support")
```

2. **Low vs High Absences (Close Call Hypothesis)**

```r
p_value_2 <- permutation_test(one, "Absence_Group", "Dropped_Out", 10000, "Low Absences", "High Absences")
```

3. **Reason for Choosing School vs Dropout**

```r
p_value_3 <- z_test_from_data(one, "Reason_for_Choosing_School", "Dropped_Out", reason_a, reason_b)
```

---

## **Visualizations**

- Barplots for dropout rates by **parental education, absences, reasons for choosing school**
- Boxplot for **Study Time vs Final Grades**
- Barplots for **average alcohol consumption by gender**

---

## **Key Insights**

- Parental education and family support significantly influence dropout rates.
- High absenteeism correlates with higher dropout likelihood.
- Alcohol consumption varies by gender but may impact academic performance.
- Students with high family relationships or combined school & family support tend to perform better.

---

## **Usage**

1. Clone this repository to your R environment.
2. Ensure `student_dropout.csv` is in your working directory.
3. Install dependencies (`devtools`, `HypothesisTesting`).
4. Run `R` or `RStudio` and execute the script step by step.
5. Inspect outputs, visualizations, and hypothesis test results.

---

## **Acknowledgements**

- Kaggle Dataset: Student Dropout Dataset
- `HypothesisTesting` package by Janish Parikh for permutation and z-tests
- R community for packages and support

