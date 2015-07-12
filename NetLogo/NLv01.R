require(RNetLogo)
############
## section 1
############

NLStart("/usr/local/netlogo-5.1.0")
NLLoadModel("/home/mz/Documents/Copy/Dropbox/XtraWork/spatial-microsim-book/NetLogo/SimpleWorldVersion3.nlogo")

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

NLQuit()

############
## section 2
############

NLStart("/usr/local/netlogo-5.1.0", gui=FALSE)
NLLoadModel("/home/mz/Documents/Copy/Dropbox/XtraWork/spatial-microsim-book/NetLogo/SimpleWorldVersion3.nlogo")

SimpleWorld <- function(time.stable = 100) {
  NLCommand("setup")
  NLDoCommandWhile (paste("(count inhabitants with [zone = 1] < 33) and",
                          "(count inhabitants with [zone = 2] < 33) and",
                          "(count inhabitants with [zone = 3] < 33) and",
                          "(time-stable <= ", time.stable, ") ") , "go")
  NLGetAgentSet("history", "inhabitants")
}

NLCommand("random-seed 42")
inhabitant.histories <- SimpleWorld(50)
NLQuit()

## analysis 
dim(inhabitant.histories)[1]*dim(inhabitant.histories)[2]
history <- as.data.frame(matrix(unlist(inhabitant.histories), ncol=4, byrow=TRUE))
colnames(history) <- c("id", "tick","income", "zone")

require(dplyr)
changes <- group_by(history, id) %>%
  mutate( change=c(0,diff(zone))) %>%
  summarize(start.income = income[1],
            end.income = tail(income,1),
            income.change = end.income - start.income,
            zone.changes = sum(change != 0)
            )

par(oma=c(0.5,4,0.5,4), mar=c(4,1,1,2), mfrow=c(1,3), xpd=FALSE)
plot(zone.changes ~ start.income , data=changes, axes=FALSE, xlab="")
axis(1)
axis(2)
mtext("Starting income", 1, line=3)
mtext( "Number of zone changes", 2, line=3)
abline(lm(zone.changes ~ start.income , data=changes))
plot(zone.changes ~ end.income , data=changes, axes=FALSE, xlab="")
axis(1)
mtext( "Final income", 1, line=3)
abline(lm(zone.changes ~ end.income , data=changes))
plot(zone.changes ~ income.change , data=changes, xlab="", axes=FALSE)
axis(1)
axis(4)
mtext( "Net income gain", 1, line=3)
mtext( "Number of zone changes", 4, line=3)
abline(lm(zone.changes ~ income.change , data=changes))
