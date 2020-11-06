library(threejs)

the_martian <- read.csv("the_martian.csv", comment.char="#")


globejs(img="Mars_Viking_MDIM21_ClrMosaic_global_1024.jpg", bodycolor="#555555", emissive="#444444", 
        lightcolor="#555555", 
        lat=the_martian$x, 
        long=the_martian$y)
