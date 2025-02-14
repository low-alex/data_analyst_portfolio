
#load packages
library(ggplot2)
library(dplyr)
library(reshape) # reshaping data frame
library(pastecs)
library(broom)
library(purrr)
library(this.path)

# Getting the path of your current open file
setwd(this.path::here())
setwd('../')
cwd <- getwd()
audiometer_df <- read.csv(file.path(cwd, 'datasource/audiometer_measurements.csv'))
kemar_calibration_df <- read.csv(file.path(cwd, 'datasource/kemar_earbud_calibration.csv'))

head(audiometer_df)

# #Categorize 
audiometer_df$Device <- as.factor(audiometer_df$Device)
audiometer_df$Side <- as.factor(audiometer_df$Side)

# Apply post calibration results to tws earbud measurements
head(kemar_calibration_df)
audiometer_cal_df <- audiometer_df

# Apply calibration to each freq bin for left side of earbud
audiometer_cal_df$F250Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side =='Left'] <-
  audiometer_cal_df$F250Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side=='Left'] - kemar_calibration_df$calibration_left[1]

audiometer_cal_df$F500Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side =='Left'] <-
  audiometer_cal_df$F500Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side=='Left'] - kemar_calibration_df$calibration_left[2]

audiometer_cal_df$F1000Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side =='Left'] <-
  audiometer_cal_df$F1000Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side=='Left'] - kemar_calibration_df$calibration_left[3]

audiometer_cal_df$F2000Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side =='Left'] <-
  audiometer_cal_df$F2000Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side=='Left'] - kemar_calibration_df$calibration_left[4]

audiometer_cal_df$F4000Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side =='Left'] <-
  audiometer_cal_df$F4000Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side=='Left'] - kemar_calibration_df$calibration_left[5]

audiometer_cal_df$F8000Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side =='Left'] <-
  audiometer_cal_df$F8000Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side=='Left'] - kemar_calibration_df$calibration_left[6]

head(audiometer_cal_df)

# Apply calibration to each freq bin for right side of earbud
audiometer_cal_df$F250Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side =='Right'] <-
  audiometer_cal_df$F250Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side=='Right'] - kemar_calibration_df$calibration_right[1]

audiometer_cal_df$F500Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side =='Right'] <-
  audiometer_cal_df$F500Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side=='Right'] - kemar_calibration_df$calibration_right[2]

audiometer_cal_df$F1000Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side =='Right'] <-
  audiometer_cal_df$F1000Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side=='Right'] - kemar_calibration_df$calibration_right[3]

audiometer_cal_df$F2000Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side =='Right'] <-
  audiometer_cal_df$F2000Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side=='Right'] - kemar_calibration_df$calibration_right[4]

audiometer_cal_df$F4000Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side =='Right'] <-
  audiometer_cal_df$F4000Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side=='Right'] - kemar_calibration_df$calibration_right[5]

audiometer_cal_df$F8000Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side =='Right'] <-
  audiometer_cal_df$F8000Hz[audiometer_cal_df$Device=='TWS earbud' & audiometer_cal_df$Side=='Right'] - kemar_calibration_df$calibration_right[6]

head(audiometer_cal_df)


# Display descriptive stats
# both sides
print(by(cbind(F250Hz=audiometer_cal_df$F250Hz, F500Hz=audiometer_cal_df$F500Hz,
               F1000Hz=audiometer_cal_df$F1000Hz, F2000Hz=audiometer_cal_df$F2000Hz,
               F4000Hz=audiometer_cal_df$F4000Hz, F8000Hz=audiometer_cal_df$F8000Hz),
         INDICES=audiometer_cal_df$Device,
         function(X) round(stat.desc(X), 2)))
         #FUN=stat.desc))

# Rearranging dataframe based on each frequency bin for repeated measures
# 250 Hz
df_250Hz = cbind(audiometer_cal_df[1:5], audiometer_cal_df[6])
tws_250Hz_df <- subset(df_250Hz, df_250Hz$Device == 'TWS earbud')
colnames(tws_250Hz_df)[6] <- "TWS"
medRx_250Hz_df <- subset(df_250Hz, df_250Hz$Device == 'Med RX')
df_250Hz <- data.frame(tws_250Hz_df, MedRx = medRx_250Hz_df$F250Hz )
df_250Hz$Frequency = "250Hz"
df_250Hz <- within(df_250Hz, rm("Round"))
df_250Hz <- within(df_250Hz, rm("Device"))

# 500 Hz
df_500Hz = cbind(audiometer_cal_df[1:5], audiometer_cal_df[7])
tws_500Hz_df <- subset(df_500Hz, df_500Hz$Device == 'TWS earbud')
colnames(tws_500Hz_df)[6] <- "TWS"
medRx_500Hz_df <- subset(df_500Hz, df_500Hz$Device == 'Med RX')
df_500Hz <- data.frame(tws_500Hz_df, MedRx = medRx_500Hz_df$F500Hz )
df_500Hz$Frequency = "500Hz"
df_500Hz <- within(df_500Hz, rm("Round"))
df_500Hz <- within(df_500Hz, rm("Device"))

# 1000 Hz
df_1000Hz = cbind(audiometer_cal_df[1:5], audiometer_cal_df[8])
tws_1000Hz_df <- subset(df_1000Hz, df_1000Hz$Device == 'TWS earbud')
colnames(tws_1000Hz_df)[6] <- "TWS"
medRx_1000Hz_df <- subset(df_1000Hz, df_1000Hz$Device == 'Med RX')
df_1000Hz <- data.frame(tws_1000Hz_df, MedRx = medRx_1000Hz_df$F1000Hz )
df_1000Hz$Frequency = "1000Hz"
df_1000Hz <- within(df_1000Hz, rm("Round"))
df_1000Hz <- within(df_1000Hz, rm("Device"))

# 2000 Hz
df_2000Hz = cbind(audiometer_cal_df[1:5], audiometer_cal_df[9])
tws_2000Hz_df <- subset(df_2000Hz, df_2000Hz$Device == 'TWS earbud')
colnames(tws_2000Hz_df)[6] <- "TWS"
medRx_2000Hz_df <- subset(df_2000Hz, df_2000Hz$Device == 'Med RX')
df_2000Hz <- data.frame(tws_2000Hz_df, MedRx = medRx_2000Hz_df$F2000Hz )
df_2000Hz$Frequency = "2000Hz"
df_2000Hz <- within(df_2000Hz, rm("Round"))
df_2000Hz <- within(df_2000Hz, rm("Device"))

# 4000 Hz
df_4000Hz = cbind(audiometer_cal_df[1:5], audiometer_cal_df[10])
tws_4000Hz_df <- subset(df_4000Hz, df_4000Hz$Device == 'TWS earbud')
colnames(tws_4000Hz_df)[6] <- "TWS"
medRx_4000Hz_df <- subset(df_4000Hz, df_4000Hz$Device == 'Med RX')
df_4000Hz <- data.frame(tws_4000Hz_df, MedRx = medRx_4000Hz_df$F4000Hz )
df_4000Hz$Frequency = "4000Hz"
df_4000Hz <- within(df_4000Hz, rm("Round"))
df_4000Hz <- within(df_4000Hz, rm("Device"))

# 8000 Hz
df_8000Hz = cbind(audiometer_cal_df[1:5], audiometer_cal_df[11])
tws_8000Hz_df <- subset(df_8000Hz, df_8000Hz$Device == 'TWS earbud')
colnames(tws_8000Hz_df)[6] <- "TWS"
medRx_8000Hz_df <- subset(df_8000Hz, df_8000Hz$Device == 'Med RX')
df_8000Hz <- data.frame(tws_8000Hz_df, MedRx = medRx_8000Hz_df$F8000Hz )
df_8000Hz$Frequency = "8000Hz"
df_8000Hz <- within(df_8000Hz, rm("Round"))
df_8000Hz <- within(df_8000Hz, rm("Device"))

dep_ttest_F250Hz <- t.test(df_250Hz$TWS, df_250Hz$MedRx, paired = TRUE)
dep_ttest_F500Hz <- t.test(df_500Hz$TWS, df_500Hz$MedRx, paired = TRUE)
dep_ttest_F1000Hz <- t.test(df_1000Hz$TWS, df_1000Hz$MedRx, paired = TRUE)
dep_ttest_F2000Hz <- t.test(df_2000Hz$TWS, df_2000Hz$MedRx, paired = TRUE)
dep_ttest_F4000Hz <- t.test(df_4000Hz$TWS, df_4000Hz$MedRx, paired = TRUE)
dep_ttest_F8000Hz <- t.test(df_8000Hz$TWS, df_8000Hz$MedRx, paired = TRUE)

tab <- map_df(list(dep_ttest_F250Hz, dep_ttest_F500Hz, dep_ttest_F1000Hz, dep_ttest_F2000Hz,
                   dep_ttest_F4000Hz, dep_ttest_F8000Hz), tidy)
freq <- c("250Hz", "500Hz", "1000Hz", "2000Hz", "4000Hz", "8000Hz")


tab <- data.frame(freq, tab[c("estimate", "statistic", "p.value", "conf.low", "conf.high")])
colnames(tab)[2] <- "mean.diff"
colnames(tab)[3] <- "t.statistic"

tab[, (2:3)] = round(tab[, (2:3)], digits=1)
tab[, (5:6)] = round(tab[, (5:6)], digits=1)
tab[, 4] = round(tab[, 4], digits=5)


df_250Hz$pMean <- (df_250Hz$TWS + df_250Hz$MedRx)/2
grandMean_250Hz <- mean(c(df_250Hz$TWS, df_250Hz$MedRx))
df_250Hz$adj <- grandMean_250Hz - df_250Hz$pMean
df_250Hz$TWS_adj <- df_250Hz$TWS + df_250Hz$adj
df_250Hz$MedRx_adj <- df_250Hz$MedRx + df_250Hz$adj

df_500Hz$pMean <- (df_500Hz$TWS + df_500Hz$MedRx)/2
grandMean_500Hz <- mean(c(df_500Hz$TWS, df_500Hz$MedRx))
df_500Hz$adj <- grandMean_500Hz - df_500Hz$pMean
df_500Hz$TWS_adj <- df_500Hz$TWS + df_500Hz$adj
df_500Hz$MedRx_adj <- df_500Hz$MedRx + df_500Hz$adj

df_1000Hz$pMean <- (df_1000Hz$TWS + df_1000Hz$MedRx)/2
grandMean_1000Hz <- mean(c(df_1000Hz$TWS, df_1000Hz$MedRx))
df_1000Hz$adj <- grandMean_1000Hz - df_1000Hz$pMean
df_1000Hz$TWS_adj <- df_1000Hz$TWS + df_1000Hz$adj
df_1000Hz$MedRx_adj <- df_1000Hz$MedRx + df_1000Hz$adj

df_2000Hz$pMean <- (df_2000Hz$TWS + df_2000Hz$MedRx)/2
grandMean_2000Hz <- mean(c(df_2000Hz$TWS, df_2000Hz$MedRx))
df_2000Hz$adj <- grandMean_2000Hz - df_2000Hz$pMean
df_2000Hz$TWS_adj <- df_2000Hz$TWS + df_2000Hz$adj
df_2000Hz$MedRx_adj <- df_2000Hz$MedRx + df_2000Hz$adj

df_4000Hz$pMean <- (df_4000Hz$TWS + df_4000Hz$MedRx)/2
grandMean_4000Hz <- mean(c(df_4000Hz$TWS, df_4000Hz$MedRx))
df_4000Hz$adj <- grandMean_4000Hz - df_4000Hz$pMean
df_4000Hz$TWS_adj <- df_4000Hz$TWS + df_4000Hz$adj
df_4000Hz$MedRx_adj <- df_4000Hz$MedRx + df_4000Hz$adj

df_8000Hz$pMean <- (df_8000Hz$TWS + df_8000Hz$MedRx)/2
grandMean_8000Hz <- mean(c(df_8000Hz$TWS, df_8000Hz$MedRx))
df_8000Hz$adj <- grandMean_8000Hz - df_8000Hz$pMean
df_8000Hz$TWS_adj <- df_8000Hz$TWS + df_8000Hz$adj
df_8000Hz$MedRx_adj <- df_8000Hz$MedRx + df_8000Hz$adj

df_new = rbind(df_250Hz, df_500Hz, df_1000Hz, df_2000Hz, df_4000Hz, df_8000Hz)

#Categorize
df_new$Frequency <-factor(df_new$Frequency, levels=c('250Hz', '500Hz', '1000Hz', '2000Hz', '4000Hz', '8000Hz'))

df_new_melt <- melt(df_new, id = c("Participant", "Gender", "Side", "TWS", "MedRx", "Frequency", "pMean", "adj"),
                    measured = c("TWS_adj", "MedRx_adj"))


bar <- ggplot(df_new_melt, aes(variable, value) ) + stat_summary(fun = mean, geom = "bar", position = "dodge") +
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", position = position_dodge(width=0.90), width = 0.2) +
  facet_wrap(~Frequency, ncol = 6) +
  labs(x = "Devices", y = "Mean dBHL", fill = "Side") +
  ylim(-5, 10) + scale_y_continuous(breaks = seq(0, 10, len = 11)) +
  ggtitle("TWS Vs MedRx")

dev.new()
print(bar)

