
# 00 chargemennt des librairies --------------------------------------------
require(reshape2)
require(zoo) # as.yearmon
require(ggplot2)
require(dplyr)
require(scales)
require(lubridate)
# 01 page d'interet DATASUD et chargement du fichier -----------------------------------------------
# Page Jeux de données publiés
# https://trouver.datasud.fr/dataset/nombre-de-donnees-publiees-dans-datasud
df0 <- read.table('https://trouver.datasud.fr/dataset/2a4d776c-ffe4-4b2a-809e-b74df666ea91/resource/78cd1d8e-6b5d-4b56-b368-37537abef29b/download/type.csv', header=TRUE, sep=';')
df_group <- read.table('https://trouver.datasud.fr/dataset/2a4d776c-ffe4-4b2a-809e-b74df666ea91/resource/9c661ffc-e7ae-4334-9333-2589d7dbf184/download/group.csv', header=TRUE, sep=';')

# on change le noms des colonnes en supprimant les points
df_group <- df_group %>% rename_all(~gsub('\\.',' ',.x))
# names(df_group)
# on format la colonne pour etre reconn comme date
df_group$date <- format(as.Date(df_group$date, "%Y-%m-%d"), "%Y-%m-%d" )
head(df_group)
str(df_group)

# on selectionne les dernieres dates de chaque moins
# https://stackoverflow.com/questions/30673626/finding-the-last-date-of-each-month-in-a-data-frame
# https://stackoverflow.com/questions/12492418/how-to-subset-a-data-frame-by-the-last-day-of-each-month
df_group_lim <- df_group[c(diff(as.numeric(substr(df_group$date, 9, 10))) < 0, TRUE), ]
str(df_group_lim)
head(df_group_lim)

# on reshape la data
me_group <-melt(df_group_lim, id='date')
str(me_group)
# on format la colonne pour etre reconnue comme date
me_group$date <- ymd(me_group$date)
# on verifie la class de la nouvelle colonne
class(me_group$date)

# https://stackoverflow.com/questions/40724142/position-geom-text-in-the-middle-of-each-bar-segment-in-a-geom-col-stacked-barch
str(me_group)

g1 <- ggplot(me_group, aes(x=date, y=value, fill=variable)) + geom_bar(aes(y=value, fill=variable), stat='identity', color="gray30") + theme(legend.position = "right")
g2 <- g1 + geom_text(color = "white", stat='identity', aes(label=me_group$value) , position= position_stack(vjust=0.5)) + scale_x_date(date_labels = "%b\n%Y") + labs(y='nombre de données', fill="thématique", title="Nombre de données publiées sur DataSud par mois", hjust =0.5)
g2
# choix de dossier de travail
setwd('G:/02_dataviz/datasud')
ggsave("group.pdf", width = 10, height = 10)
