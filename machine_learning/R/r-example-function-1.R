# R DANGER:
# приведение типов!!

r_example_function_1<-function()
{
  data <- read.csv("gnu-r-example.csv", header=F)
  expdata <- exp(data[,1])
  write.csv(expdata, "output_gnu-r-example.csv", row.names=FALSE)
  # column.names=FALSE)  # Don't work
} 
#r_example_function_1()