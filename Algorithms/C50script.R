#install.packages("caret")
#install.packages("e1071")
#install.packages('C50')
library(C50)
library(tidyr)
library(caret)
set.seed(123)
df <- read.csv("Titanic/train.csv", na.strings = "")
df$Survived <- as.factor(df$Survived)
df$Pclass <- as.factor(df$Pclass)
df$Sex=as.numeric(df[,'Sex'] == "male")
df <- df[,-c(1,4,9)]
control <- trainControl(method="cv", number=8)
fit.c50 <- train(Survived~., data=df, method="C5.0", metric="Accuracy", trControl=control,na.action = na.pass)

new_df <-read.csv('Titanic/test.csv',na.strings = "")
ids<- new_df$PassengerId
new_df$Pclass<- as.factor(new_df$Pclass)
new_df$Sex=as.numeric(new_df[,'Sex'] == "male")
new_df<- new_df[,-c(1,3,8)]
fit.c50$xlevels[["Cabin"]] <- union(fit.c50$xlevels[["Cabin"]], levels(new_df$Cabin))
new_pred<- predict(fit.c50,new_df,na.action = na.pass)
res <- cbind(PassengerId=ids,Survived=as.character(new_pred))
write.csv(res,file="Titanic/try6.csv",row.names = F)