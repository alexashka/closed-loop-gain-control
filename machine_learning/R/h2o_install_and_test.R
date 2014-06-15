# http://blog.revolutionanalytics.com/2014/04/a-dive-into-h2o.html
# http://sjsubigdata.wordpress.com/2014/04/24/oxdata-h2o-tutorial/

# java -Xmx1g -jar h2o.jar
# The following two commands remove any previously installed H2O packages for R.
if ("package:h2o" %in% search()) { detach("package:h2o", unload=TRUE) }
if ("h2o" %in% rownames(installed.packages())) { remove.packages("h2o") }
 
# Next, we download, install and initialize the H2O package for R.
# TODO: версия должна точно соответсвовать
# Нужен RCurl and rjson для первого нужны 
#http://askubuntu.com/questions/359267/cannot-find-curl-config-in-ubuntu-13-04
#http://stackoverflow.com/questions/17231235/how-to-install-a-package-not-located-on-cran
#libcurl4-gnutls-dev
# install.packages('foo.zip', repos = NULL)
install.packages("h2o", repos=(c("http://s3.amazonaws.com/h2o-release/h2o/rel-kahan/5/R", getOption("repos"))))
 
library(h2o)
localH2O = h2o.init()
 
# Finally, let's run a demo to see H2O at work.
demo(h2o.glm)