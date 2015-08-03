require(RNetLogo)
require(dplyr)
require(ggplot2)
require(extrafont)
loadfonts()

############
## section 1
############
NLStart("C:\\Program Files (x86)\\NetLogo 5.1.0")
NLLoadModel("C:/Users/sfos0247/Copy/Dropbox/XtraWork/spatial-microsim-book/NetLogo/SimpleWorldVersion3.nlogo")

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
current.state <- NLGetAgentSet(c("who","income", "zone"), 
                               "inhabitants")
boxplot(current.state$income~current.state$zone,
        xlab="Zone", ylab="Income", main=paste("Income distribution after",
                                               NLReport("ticks"), "ticks" ))

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


## section 3
require(RNetLogo)
require(dplyr)
require(ggplot2)
require(extrafonts)
loadfonts()

NLStart("C:\\Program Files (x86)\\NetLogo 5.1.0", gui=FALSE)
NLLoadModel("C:/Users/sfos0247/Copy/Dropbox/XtraWork/spatial-microsim-book/NetLogo/SimpleWorldVersion3.nlogo")
setwd("C:/Users/sfos0247/Copy/Dropbox/XtraWork/spatial-microsim-book/NetLogo")


SimpleWorld <- function(angle.of.vision=360, distance.of.vision=10, time.stable = 200) {
  NLCommand (paste("set average-bribeability", 100))
  NLCommand (paste("set stdev-bribeability", 0))
  NLCommand (paste("set angle-of-vision", angle.of.vision))
  NLCommand (paste("set distance-of-vision", distance.of.vision))
  NLCommand("setup")
  NLDoCommandWhile (paste("(time-stable <= ", time.stable, ") ") , "go")
  c(NLReport(c("ticks - time-stable", nrow(unique(NLGetAgentSet( "zone", "inhabitants"))))))
}

MultipleSimulations <- function (reps=1, a.o.v = 360, d.o.v = c(5,10)){
  p.s <- expand.grid(rep = seq(1, reps), a.o.v = a.o.v, d.o.v = d.o.v) 
  reslut.list <- lapply(as.list(1:nrow(p.s)), function(i) 
    setNames(cbind(p.s[i,], SimpleWorld(p.s[i,2], p.s[i,3])), c("rep", "a.o.v", "d.o.v", "ticks", "zones")))
  do.call(rbind, reslut.list)
}

MultipleSimulations(2,360,c(5,10))

# results.df <-   MultipleSimulations2(20,seq(60,360,30),seq(1,10))
#save(results.df, file="multiSimRun.R")
load("multiSimRun.R")
head(results.df)



# summaries for plots
av.ticks2 <- results.df %>%
  group_by(a.o.v, d.o.v) %>%
 # filter(zones == 1) %>%
  summarize(mean.ticks = mean(ticks, na.rm=TRUE))

zones <- results.df %>%
  group_by(a.o.v, d.o.v, zones) %>%
  summarize(height = n()/20) %>%
  group_by(a.o.v, d.o.v) %>%
  arrange(desc(zones)) %>%
  mutate(shift=-0.5 + cumsum(height)-height + height/2)


## fig 10
png(file="zones.png", height=450, width=750, family="Garamond") 

ggplot(zones, aes(a.o.v,y=d.o.v + shift, fill=as.factor(zones), height=height)) + 
  geom_tile(col="white") + xlab('aov') + ylab('dov') +
  scale_fill_manual(values=c("gray30", "gray50",
                             "gray80"), name="No of zones") +
  theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(), 
                     panel.grid.minor = element_blank(),axis.text=element_text(size=16),
                     title=element_text(size=16),
                     legend.text=element_text(size=12),
                     legend.key = element_rect(colour = "white")) +
  scale_x_continuous(breaks=seq(60,360,30) ) +
  scale_y_continuous(breaks=seq(1,10,1) ) +
  xlab("Angle of vision") +
  ylab("Distance of vision") +
  guides(fill = guide_legend(override.aes = list(colour = NULL))) 
dev.off()

##fig 11
png(file="ticks.png", height=450, width=750, family="Garamond") 
ggplot(av.ticks, aes(a.o.v,y=d.o.v , fill=mean.ticks)) + 
  geom_tile(col="white")+
  theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(), 
                     panel.grid.minor = element_blank(), axis.text=element_text(size=16),
                     title=element_text(size=16),
                     legend.text=element_text(size=12)) +
  scale_x_continuous(breaks=seq(60,360,30) ) +
  scale_y_continuous(breaks=seq(1,10) ) +
  scale_fill_gradient(name = "Tick count", trans = "log",low="gray80",high="gray20", 
                      breaks=c(50,100, 500, 1000, 5000)) +
  xlab("Angle of vision") +
  ylab("Distance of vision")
dev.off()

