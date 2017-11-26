# Algorithm \#1: rpart (basic algorithm)

## Data Preprocessing 
We first converted the columns _Survived, Pclass,_ and _Embarked_ into factors:

```{r}
df <- read.csv("Titanic/train.csv",na.strings = "")
df$Survived <- as.factor(df$Survived)
df$Pclass <- as.factor(df$Pclass)
df$Embarked <- as.factor(df$Embarked)
df.numeric <- df
```
Then we converted the _Sex_ column into a numeric column (of 1's and 0's):
```{r}
df.numeric$Sex=as.numeric(df.numeric[,'Sex'] == "male")
```
Finally, we omitted the columns that we found to be irrelevant for this basic algorithm:
```{r}
df.numeric <- df.numeric[,-c(1,4,9,11)]
```

## Algorithm Description
For this algorithm we used the rpart package, which grows a decision tree and 
```{r}
titanic.rpart <- rpart(Survived ~ ., data = df.numeric,method="class")
```
![Image of plot](/images/Rpart.png)
