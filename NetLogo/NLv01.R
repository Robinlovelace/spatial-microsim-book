require(RNetLogo)

# NLStart("C:/Program Files\ (x86)/NetLogo\ 5.1.0", gui=FALSE)
NLStart("/usr/local/netlogo-5.1.0")
#NLLoadModel(file.path("C:\\Users\\sfos0247\\Copy\\Dropbox\\XtraWork\\spatial-microsim-book\\NetLogo\\SimpleWorldVersion2.nlogo"))
#NLLoadModel("C:\\Users\\sfos0247\\Copy\\Dropbox\\XtraWork\\spatial-microsim-book\\NetLogo\\test.nlogo")
NLLoadModel("/home/mz/Documents/Copy/Dropbox/XtraWork/spatial-microsim-book/NetLogo/test.nlogo")


NLCommand("setup")
NLReport("ticks")
NLCommand("go")
NLReport("ticks")
NLDoCommand(50,"go")
NLReport("ticks")
test <- NLDoReport(10,"go", c(" ticks",
                              "count inhabitants with [zone = 1]",
                              "count inhabitants with [zone = 2]",
                              "count inhabitants with [zone = 3]"), 
                   as.data.frame = TRUE)
head(test)
current.state <- NLGetAgentSet(c("who","income", "zone"), "inhabitants")
boxplot(current.state$income~current.state$zone,
        xlab="Zone", ylab="Income", main=paste("Income distribution after",NLReport("ticks"), "ticks" ))


NLDoCommandWhile (" (ticks <= 100) " , "go")
NLReport("ticks")


NLDoCommandWhile (" (count inhabitants with [zone = 1] = 33) or
                  (count inhabitants with [zone = 2] = 33) or
                  (count inhabitants with [zone = 3] = 33) or
                  (ticks <= 1000) " , "go", 
                  max.minutes=1)
NLQuit()


## section 2

NLStart("/usr/local/netlogo-5.1.0", gui=FALSE)
#NLLoadModel(file.path("C:\\Users\\sfos0247\\Copy\\Dropbox\\XtraWork\\spatial-microsim-book\\NetLogo\\SimpleWorldVersion2.nlogo"))
#NLLoadModel("C:\\Users\\sfos0247\\Copy\\Dropbox\\XtraWork\\spatial-microsim-book\\NetLogo\\test.nlogo")
NLLoadModel("/home/mz/Documents/Copy/Dropbox/XtraWork/spatial-microsim-book/NetLogo/test.nlogo")

NL <- function(){
  NLCommand("setup")
  NLDoCommand ( 100, "go")
  NLReport("ticks")
}

NLCommand("setup")
NLDoCommand ( 100, "go")
NLReport("time-stable")
NLReport("inhabitant-distribution")


