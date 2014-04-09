### Kleines Beispiel, wie man apply/lapply etc. statt Schleifen 
  # ineinander schachtelt. Das ist im Hinblick auf eine Para-
  # lellisierung mittels parSapply/parLapply etc sehr zeit-
  # sparend!

###############
# Beispiel:
# Man hat meherere Datensätze simuliert (bspw. mit verschiedenen
# Parametern oder Verteilungsannahmen) und über die einzelnen Variablen
# /Spalten oder Zeilen dieser Datensätze möchte man nun eine Funktion
# laufen lassen; zudem sind die unterschiedlichen Datensätze in eine
# Liste gepackt, wobei jedes Listenelement einem Datensatz entspricht:

gleichvert <-  matrix(runif(800, 0, 1), ncol=8, byrow=T)
colnames(gleichvert) <- letters[1:8]

normalvert <-  matrix(rnorm(800, 0, 1), ncol=8, byrow=T)
colnames(normalvert) <- letters[1:8]

chivert <-  matrix(rchisq(800, 2, 1), ncol=8, byrow=T)
colnames(chivert) <- letters[1:8]

liste.rand <- vector(mode="list", length=3)
liste.rand[[1]] <- gleichvert
liste.rand[[2]] <- normalvert
liste.rand[[3]] <- chivert

# Statt jetzt jedes Listenelement in einer for-Schleife und dann
# noch mal jede Zeile oder Spalte mit einer for-Schleife anzusteuern:

# for(i in seq_along(liste.rand)){
#   for(j in seq_along(liste.rand[[i]][,1])){
#     function()
#   }
# }

# kann eleganter ein äußeres lapply und ein inneres apply gewählt
# werden; in diesem Fall ist gewünscht, dass die Werte in den 
# Spalten (!) sortiert werden (darum muss MARGIN=2 gestezt werde):

beispiel_spalte <- lapply(c(1,2,3), FUN=function(var){    
  apply(liste.rand[[var]], MARGIN=2,         
        
        FUN=function(x){
          sort(x)[]
        }
  )
}
)

# Soll über die Zeilen (!) sortiert werden, ist  MARGIN=1 zu setzen:

beispiel_zeile <- lapply(c(1,2,3), FUN=function(var){    
  apply(liste.rand[[var]], MARGIN=2,         
        
        FUN=function(x){
          sort(x)[]
        }
  )
}
)

# Wichtig bei einem apply ist bloss, dass die Dimensionsanzahl
# passen muss: apply mit MARGIN=1 funktioniert nicht auf einen
# Vektor, da dieser für R nur aus einer Dimension (Spalte)
# besteht.