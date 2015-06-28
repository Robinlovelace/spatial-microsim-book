require(rJava)
require(RNetLogo)

NLStart("C:/Program Files\ (x86)/NetLogo\ 5.1.0", gui=FALSE)
NLLoadModel(file.path("C:\\Users\\sfos0247\\Copy\\Dropbox\\XtraWork\\spatial-microsim-book\\NetLogo\\SimpleWorldVersion2.nlogo"))
NLLoadModel("C:\\Users\\sfos0247\\Copy\\Dropbox\\XtraWork\\spatial-microsim-book\\NetLogo\\test.nlogo")

NLCommand ("setup")
NLReport("ticks")
NLDoCommand(200,"go")
NLDoReport(20,"go", "ticks")

hist <- NLGetAgentSet(c("history"), "inhabitants")
t(hist)

NLDoCommandWhile (" (ticks <= 10) " , "go")

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

current.state <- NLGetAgentSet(c("who","income", "zone"), "inhabitants")
boxplot(current.state$income~current.state$zone,
        xlab="Zone", ylab="Income", main=paste("Income distribution after",NLReport("ticks"), "ticks" ))




NLDoCommandWhile (" (count inhabitants with [zone = 1] < 33) or
                  (count inhabitants with [zone = 2] < 33) or
                  (count inhabitants with [zone = 3] < 33) or
                  (ticks <= 10) " , "go")




NLQuit()



