shop<- read.table("lab3_selfdata.csv", header=T, sep=";")
shop
plot(shop)
distance=array(0,c(5,5))
for(i in 1:5) { for (j in 1:5){distance[i,j]=abs(shop$v1[i]-shop$v1[j])+abs(shop$v2[i]-shop$v2[j])}}
distance

