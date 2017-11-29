#install all packeges from lines 2-7
library(rpart)
library(missForest)
library(caretEnsemble)
library(C50)
library(tidyr)
library(caret)
set.seed(123)
df <- read.csv("Titanic/train.csv",na.strings = "")
df$Survived <- as.factor(df$Survived)
df$Pclass <- as.factor(df$Pclass)
df$Embarked <- as.factor(df$Embarked)
df.numeric <- df
df.numeric$Sex=as.numeric(df.numeric[,'Sex'] == "male")
df.numeric <- df.numeric[,-c(1,4,9,11)]
df.numeric <- missForest(df.numeric, maxiter = 10, ntree = 100)
df.numeric <- df.numeric$ximp
levels(df.numeric$Survived) <- c("NO","Yes")
control <- trainControl(method="cv", number=8,savePredictions = 'final',classProbs = TRUE)
models <- caretList(
  Survived ~ .,
  data = df.numeric,
  trControl = control,
  metric = "Accuracy",
  methodList = c("rpart","C5.0","glm")
)
greedy_ensemble <- caretEnsemble(models)
new_df <-read.csv('Titanic/test.csv',na.strings = "")
ids<- new_df$PassengerId
new_df$Pclass <- as.factor(new_df$Pclass)
new_df$Embarked <- as.factor(new_df$Embarked)
new_df.numeric <- new_df
new_df.numeric$Sex=as.numeric(new_df.numeric[,'Sex'] == "male")
new_df.numeric <- new_df.numeric[,-c(1,3,8,10)]
new_df.numeric <- missForest(new_df.numeric, maxiter = 10, ntree = 100)
new_df.numeric <- new_df.numeric$ximp
pred = predict(greedy_ensemble,newdata=new_df.numeric)
func <- function(str){
  if(str=="Yes")
    return(1)
  else
  return(0)
}
pred=sapply(pred, func)
res <- cbind(PassengerId=ids,Survived=as.character(pred))
write.csv(res,file="Titanic/ensemble.csv",row.names = F)