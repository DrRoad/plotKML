# Purpose        : Default methods to plot sp-type objects;
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl); 
# Contributions  : ;
# Dev Status     : pre-Alpha
# Note           : these functions can be further customized;


setMethod("plotKML", "SpatialPointsDataFrame", function(obj, folder.name = normalizeFilename(deparse(substitute(obj, env=parent.frame()))), file.name = paste(normalizeFilename(deparse(substitute(obj, env=parent.frame()))), ".kml", sep=""), size, colour, points_names, shape = "http://maps.google.com/mapfiles/kml/pal2/icon18.png", metadata = NULL, kmz = TRUE, ...){

  # Guess aesthetics if missing:
  if(missing(size)){ 
    obj@data[,"size"] <- obj@data[,1]
  } else {
    if(is.name(size)|is.call(size)){
      obj@data[,"size"] <- eval(size, obj@data)
    } else {
      obj@data[,"size"] <- obj@data[,deparse(size)]      
    }
  }
  if(missing(colour)){ 
    obj@data[,"colour"] <- obj@data[,1] 
    message("Plotting the first variable on the list")  
  } else {
    if(is.name(colour)|is.call(colour)){
      obj@data[,"colour"] <- eval(colour, obj@data)
    } else {
      obj@data[,"colour"] <- obj@data[,as.character(colour)]      
    }
  }
  if(missing(points_names)){ 
    if(is.numeric(obj@data[,1])){ 
      points_names <- signif(obj@data[,1], 3) 
    } else {
      points_names <- paste(obj@data[,1])     
    }
  }
    
  # open for writing:
  kml_open(folder.name = folder.name, file.name = file.name, ...)
 
  # write layer:
  kml_layer.SpatialPoints(obj, size = size, colour = colour, points_names = points_names, shape = shape, metadata = metadata, ...)

  # close the file:
  kml_close(file.name = file.name)
  if (kmz == TRUE){
      kml_compress(file.name = file.name)
  }
  # open KML file in the default browser:
  kml_View(file.name)

})


setMethod("plotKML", "SpatialLinesDataFrame", function(obj, folder.name = normalizeFilename(deparse(substitute(obj, env=parent.frame()))), file.name = paste(normalizeFilename(deparse(substitute(obj, env=parent.frame()))), ".kml", sep=""), metadata = NULL, kmz = TRUE, ...){
   
  # open for writing:
  kml_open(folder.name = folder.name, file.name = file.name, ...)
 
  # write layer:
  kml_layer.SpatialLines(obj, metadata = metadata, ...)

  # close the file:
  kml_close(file.name = file.name)
  if (kmz == TRUE){
      kml_compress(file.name = file.name)
  }
  # open KML file in the default browser:
  kml_View(file.name)

})


setMethod("plotKML", "SpatialPolygonsDataFrame", function(obj, folder.name = normalizeFilename(deparse(substitute(obj, env=parent.frame()))), file.name = paste(normalizeFilename(deparse(substitute(obj, env=parent.frame()))), ".kml", sep=""), colour, plot.labpt, labels, metadata = NULL, kmz = TRUE, ...){

  # Guess aesthetics if missing:
  if(missing(labels)){ 
    obj@data[,"labels"] <- obj@data[,1] 
  } else {
    if(is.name(labels)|is.call(labels)){
      obj@data[,"labels"] <- eval(labels, obj@data)
    } else {
      obj@data[,"labels"] <- obj@data[,deparse(labels)]      
    }
  }
  if(missing(colour)){ 
    obj@data[,"colour"] <- obj@data[,1]
    message("Plotting the first variable on the list")
  } else {
    if(is.name(colour)|is.call(colour)){
      obj@data[,"colour"] <- eval(colour, obj@data)
    } else {
      obj@data[,"colour"] <- obj@data[,as.character(colour)]      
    }
  }
  if(missing(plot.labpt)){ plot.labpt <- TRUE }
    
  # open for writing:
  kml_open(folder.name = folder.name, file.name = file.name, ...)
 
  # write layer:
  kml_layer.SpatialPolygons(obj, colour = colour, plot.labpt = plot.labpt, labels = labels, metadata = metadata,  ...)

  # close the file:
  kml_close(file.name = file.name)
  if (kmz == TRUE){
      kml_compress(file.name = file.name)
  }
  # open KML file in the default browser:
  kml_View(file.name)

})

## Pixels Grids Raster
.plotKML.SpatialPixels <- function(obj, folder.name = normalizeFilename(deparse(substitute(obj, env=parent.frame()))), file.name = paste(normalizeFilename(deparse(substitute(obj, env=parent.frame()))), ".kml", sep=""), colour, raster_name, metadata = NULL, kmz = FALSE, ...){

  # the kml_layer.Raster works only with "Spatial" class:
  if(class(obj)=="RasterLayer"){
    obj <- as(obj, "SpatialGridDataFrame")
  }

  # Guess aesthetics if missing:
  if(missing(colour)){ 
    obj@data[,"colour"] <- obj@data[,1]
    message("Plotting the first variable on the list") 
  } else {
    if(is.name(colour)|is.call(colour)){
      obj@data[,"colour"] <- eval(colour, obj@data)
    } else {
      obj@data[,"colour"] <- obj@data[,as.character(colour)]      
    }
  }
  if(missing(raster_name)){ 
    raster_name <- set.file.extension(names(obj)[1], ".png")
  }
   
  # open for writing:
  kml_open(folder.name = folder.name, file.name = file.name, ...)
 
  # write layer:
  kml_layer.SpatialPixels(obj, colour = colour, raster_name = raster_name, metadata = metadata, ...)

  # close the file:
  kml_close(file.name = file.name)
  if (kmz == TRUE){
      kml_compress(file.name = file.name)
  }
  # open KML file in the default browser:
  kml_View(file.name)

}

setMethod("plotKML", "SpatialPixelsDataFrame", .plotKML.SpatialPixels)
setMethod("plotKML", "SpatialGridDataFrame", .plotKML.SpatialPixels)
setMethod("plotKML", "RasterLayer", .plotKML.SpatialPixels)


setMethod("plotKML", "SpatialPhotoOverlay", function(obj, folder.name = normalizeFilename(deparse(substitute(obj, env=parent.frame()))), file.name = paste(normalizeFilename(deparse(substitute(obj, env=parent.frame()))), ".kml", sep=""), dae.name, kmz = TRUE, ...){
  
  x <- strsplit(obj@filename, "/")[[1]]
  image.id <- x[length(x)]
  if(missing(dae.name)){ dae.name <- gsub(x=image.id, "\\.", "_") }
    
  # open for writing:
  kml_open(folder.name = folder.name, file.name = file.name, ...)
 
  # write layer:
  kml_layer.SpatialPhotoOverlay(obj, ...)

  # close the file:
  kml_close(file.name = file.name)
  if (kmz == TRUE){
      kml_compress(file.name = file.name, files=dae.name)
  }
  # open KML file in the default browser:
  kml_View(file.name)

})


setMethod("plotKML", "SoilProfileCollection", function(obj, folder.name = normalizeFilename(deparse(substitute(obj, env=parent.frame()))), file.name = paste(normalizeFilename(deparse(substitute(obj, env=parent.frame()))), ".kml", sep=""), var.name, metadata = NULL, kmz = TRUE, ...){
  
  if(missing(var.name)){ var.name <- names(obj@horizons)[!(names(obj@horizons) %in% c(prof1@idcol, obj@depthcols))][1] }
    
  # open for writing:
  kml_open(folder.name = folder.name, file.name = file.name, ...)
 
  # write layer:
  kml_layer.SoilProfileCollection(obj, var.name = var.name, balloon = TRUE, metadata = metadata, ...)

  # close the file:
  kml_close(file.name = file.name)
  if (kmz == TRUE){
      kml_compress(file.name = file.name)
  }
  # open KML file in the default browser:
  kml_View(file.name)

})

## spacetime irregular vectors
setMethod("plotKML", "STIDF", function(obj, folder.name = normalizeFilename(deparse(substitute(obj, env=parent.frame()))), file.name = paste(normalizeFilename(deparse(substitute(obj, env=parent.frame()))), ".kml", sep=""), colour, shape = "http://maps.google.com/mapfiles/kml/pal2/icon18.png", points_names, kmz = TRUE, ...){

  # Guess aesthetics if missing:
  if(missing(colour)){ 
    obj@data[,"colour"] <- obj@data[,1]
    message("Plotting the first variable on the list") 
  } else {
    if(is.name(colour)|is.call(colour)){
      obj@data[,"colour"] <- eval(colour, obj@data)
    } else {
      obj@data[,"colour"] <- obj@data[,as.character(colour)]      
    }
  }
  if(missing(points_names)){ 
    if(is.numeric(obj@data[,1])){ 
      points_names <- signif(obj@data[,1], 3) 
    } else {
      points_names <- paste(obj@data[,1])     
    }
  }
    
  # open for writing:
  kml_open(folder.name = folder.name, file.name = file.name, ...)
 
  # write layer:
  kml_layer.STIDF(obj, shape = shape, colour = colour, points_names = points_names, ...)

  # close the file:
  kml_close(file.name = file.name)
  if (kmz == TRUE){
      kml_compress(file.name = file.name)
  }
  # open KML file in the default browser:
  kml_View(file.name)

})

## Trajectories:
setMethod("plotKML", "STTDF", function(obj, folder.name = normalizeFilename(deparse(substitute(obj, env=parent.frame()))), file.name = paste(normalizeFilename(deparse(substitute(obj, env=parent.frame()))), ".kml", sep=""), colour, start.icon = "http://maps.google.com/mapfiles/kml/pal2/icon18.png", kmz = TRUE, ...){
                            
  # Guess aesthetics if missing:
  if(missing(colour)){ 
    obj@data[,"colour"] <- obj@data[,1]
    message("Plotting the first variable on the list") 
  } else {
    if(is.name(colour)|is.call(colour)){
      obj@data[,"colour"] <- eval(colour, obj@data)
    } else {
      obj@data[,"colour"] <- obj@data[,as.character(colour)]      
    }
  }
    
  # open for writing:
  kml_open(folder.name = folder.name, file.name = file.name, ...)
 
  # write layer:
  kml_layer.STTDF(obj, colour = colour, start.icon = start.icon, ...)

  # close the file:
  kml_close(file.name = file.name)
  if (kmz == TRUE){
      kml_compress(file.name = file.name)
  }
  # open KML file in the default browser:
  kml_View(file.name)

})


# end of script;