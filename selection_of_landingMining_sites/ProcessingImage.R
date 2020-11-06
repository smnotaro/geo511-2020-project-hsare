#Detecting water on the Moon to select best landing sites
#Classifying the abundance of water on Satellite Imagery in R
#Loading packages and preparing the data
library(raster)
library(tidyverse)
library(sf)
library(rpart)
library(rpart.plot)
library(rasterVis)
library(mapedit)
library(mapview)
library(caret)
library(forcats)
library(sp)
library(raster)
#Next, we read in the different bands that comprise the satellite imagery. Each band refers to a different spectrum:
#MAYBE NEED TO UPLOAD IMAGES IN THE DIRECTRY FIRST
band1 <- raster("B02.tif")
band2 <- raster("B03.tif")
band3 <- raster("B04.tif")
band4 <- raster("B05.tif")
band5 <- raster("B06.tif")
band6 <- raster("B07.tif")
band7 <- raster("B08.tif")
#band8 <- ("mariner-9-mars-lander.jpg")
#band9 <- raster("./data/band9.tif")
#band10 <- raster("./data/band10.tif")
#band11 <- raster("./data/band11.tif")
print(band1)

#Check size of image before combining them using STACK
res(band1) #SIZE FID IS 10X10
res(band2) #10X10
res(band3) #10X10
res(band4) # SIZE FIND IS 20X20
res(band5) #20X20
res(band6) #20X20
res(band7) #10X10

#LET MAKE THEM THE SAME SIZE
band1 <- aggregate(band1, fact = 2) # Multiply the size of band1 by 2 to have 20X20
band2 <- aggregate(band2, fact = 2) # Multiply the size of band2 by 2 to have 20X20
band3 <- aggregate(band3, fact = 2) # Multiply the size of band3 by 2 to have 
band7 <- aggregate(band7, fact = 2) # Multiply the size of band7 by 2 to have 20X20

#Now we can add of bands together

image <- stack(band1, band2, band3, band7)
              
#Exploring the imagery
nlayers(image)   # give number of bands            
crs(image) #the coordinate system the imagery is projected in, and the resolution (or grid cell size) of the raster.
res #resolution of the images

#Now that we know a little more about the imagery we are using, let plot it. Since image is a multi-band raster,
#we use the plotRGB function from the raster package, which allows us to specify what bands should be visualized.

#TRUE COLOR PLOTS. It uses the red band (4) for red, the green band (3) for green, and the blue band (2) for blue.
par(col.axis="white",col.lab="white",tck=0)
plotRGB(image, r = 4, g = 3, b = 2, axes = TRUE, 
        stretch = "lin", main = "True Color Composite")
box(col="white")

#FALSE COLOR PLOT.The false color composite uses NIR (5) for red, red (4) for green, and green (3) for blue.
par(col.axis="white",col.lab="white",tck=0)
plotRGB(image, r = 5, g = 4, b = 3, axes = TRUE, stretch = "lin", main = "False Color Composite")
box(col="white")

#Indices of WATER
#We can use Modified Normalized Difference Water Index [MNDWI=(Green-MIR)/ (Green+MIR)] to separate water from land.
#Reference=https://www.researchgate.net/post/What_is_the_best_band_combination_for_highlighting_the_water_and_soil_together_in_LANDSAT_image2
#Author of the reference=Saygin Abdikan currently works at the Department of Geomatics Engineering, Hacettepe University
#Author researchGate=https://www.researchgate.net/profile/Saygin_Abdikan

###[MNDWI=(Green-MIR)/ (Green+MIR)]
MNDWI <- (image[[2]] - image[[3]])/(image[[2]] + image[[3]])


#To plot the results with ggplot, we convert the raster into a data frame and use geom_tile.
as(MNDWI, "SpatialPixelsDataFrame") %>% 
  as.data.frame() %>%
  ggplot(data = .) +
  geom_tile(aes(x = x, y = y, fill = layer)) +
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.background = element_blank(),
        panel.grid.minor = element_blank()) +
  labs(title = "Water or Water ice or Volatiles materials", 
       x = " ", 
       y = " ") +
  scale_fill_gradient(high = "#CEE50E", 
                      low = "#087F28",
                      name = "Water or Water ice or Volatiles materials")
