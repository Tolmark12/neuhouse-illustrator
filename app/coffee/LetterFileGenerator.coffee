class LetterFileGenerator

  chars :
    alphaNumeric : ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    symbols      : ["(",")","[","]","{","}","|","\\","/","#","@","$","&","*","+","<",">"]

  constructor: ( @fontDestination ) ->
    # console.log @findHeight()
    # items = document.getItems({hidden:false})
    # @drawNailPoints items[0], items[1]
  
  # API -------------------

  generateLetterLayers : (txt, letterHeight, fontRef) ->
    @setBoltSize letterHeight
    @findScaleRatio fontRef, letterHeight
    lines = @addHangLines()
    text  = @addTxt txt.toUpperCase(), fontRef
    text.scale -1, 1

    count = 0
    for letter in text.children
      layer = new Layer()
      layer.name = count
      layer.appendTop letter
      for line in lines
        @drawNailPoints letter, line
      count++

    lines[0].remove()
    lines[1].remove()

  generateSVG : (fontRef) ->
    @findScaleRatio fontRef, 5
    chars = @chars.alphaNumeric.join("") + @chars.symbols.join("")
    text = @addTxt chars, fontRef

    count = chars.length-1
    for letter in text.children
      layer = new Layer()
      layer.name = chars.charAt count--
      layer.appendTop letter


  # HELPERS ----------------

  copyLayerToNewDocument : (layer) ->
    document  = new Document(layer.name, 1000, 1000)
    activeDoc.activate()
    layer.copyTo document
  

  addHangLines : () ->
    lftX = -300
    rgtX = 70000
    # topY = @topArmHeight
    # btmY = @capHeight - @topArmHeight
    topY = @topArmHeight
    btmY = @capHeight - @topArmHeight
    
    topPath = new Path.Line new Point(lftX, topY), new Point(rgtX, topY)
    btmPath = new Path.Line new Point(lftX, btmY), new Point(rgtX, btmY)
    return [topPath, btmPath]

  addTxt : (text="Sample Text", fontRef) ->
    txt = new PointText()
    txt.characterStyle.font = fontRef
    txt.paragraphStyle.justification = "left"
    txt.content = text
    outlinedTxt = txt.createOutline()
    outlinedTxt.fillColor = null
    outlinedTxt.stroke = null
    outlinedTxt.strokeWidth = 0.425
    outlinedTxt.strokeColor = new RGBColor 0, 0, 0
    txt.remove()
    outlinedTxt.scale @scaleRatio, new Point(0,0)
    # Weird bug, if I don't add some number to the capheight, it bonks..
    outlinedTxt.position = new Point(outlinedTxt.bounds.width/2, outlinedTxt.position.y + @capHeight+0.001)
    return outlinedTxt

  findScaleRatio : (fontRef,letterHeight) ->
    # Draw a capital X
    txt = new PointText()
    txt.characterStyle.font = fontRef
    txt.content = "X"
    o = txt.createOutline()

    # Scale it to the target height
    targetHeight = 72*letterHeight
    @scaleRatio  = targetHeight / o.bounds.height
    o.scale(@scaleRatio)

    # Save the capheight, yposition and scaleratio
    @capHeight  = o.bounds.height
    o.position  = new Point(0, o.position.y + @capHeight)

    # Find out how big close the weld marks should be from the edge
    o.remove()
    txt.content = "T"
    o = txt.createOutline()
    o.scale @scaleRatio, new Point(0,0)
    txt.remove()
    
    o.position = new Point(o.bounds.width/2, o.position.y + @capHeight)

    # Find the vertical stem of the 'T'
    path = new Path.Line new Point(-30, o.bounds.height*0.6), new Point(700000, o.bounds.height*0.6)
    intersections = o.children[0].getIntersections( path)
    intersections = @sortPointsByAxis intersections, 'x'
    xPos = intersections[0].point.x - o.bounds.width*0.05
    path.remove()

    path = new Path.Line new Point(xPos , -30), new Point(xPos, 700000)
    intersections = o.children[0].getIntersections( path)
    intersections = @sortPointsByAxis intersections, 'y'
    @topArmHeight = intersections[0].point.y + (intersections[1].point.y - intersections[0].point.y)/2
    
    path.remove()
    o.remove() 
  
  drawNailPoints : (obj1, obj2) ->
    intersections = obj1.getIntersections obj2
    @sortPointsByAxis intersections

    for intersection, i in intersections by 2
      midPoint = new Point()
      midPoint.y = intersection.point.y
      midPoint.x = intersections[i].point.x + (intersections[i+1].point.x - intersections[i].point.x)/2

      bolt =  new Path.RegularPolygon( new Point(midPoint.x, midPoint.y), 6, @boltWidth )
      bolt.fillColor = null
      bolt.strokeWidth = 0.709
      bolt.strokeColor = new RGBColor 0, 0, 0
      bolt.dashArray   = [63.11, 12.62, 12.62, 12.62];


  addArtboard : () ->
    artBoard = new Artboard( new Rectangle(360+20,0,360, 360) )
    document.artboards.push artBoard
    document.artboard = artBoard
  
  # --------------------------------- HELPERS

  setBoltSize : (letterHeight) ->
    eighthOfAnInch = 0.13*72
    if letterHeight <= 12
      @boltWidth = eighthOfAnInch*1
    else if letterHeight <= 19
      @boltWidth = eighthOfAnInch*2
    else 
      @boltWidth = eighthOfAnInch*3
  

  sortPointsByAxis : (ar, axis='x') ->
    ar.sort (A,B) ->
      if      A.point[axis] < B.point[axis] then return -1
      else if A.point[axis] > B.point[axis] then return 1
      else                                 return 0
  

  addAllCharactersToDocument : () ->
    txt = new PointText()
    txt.content = @txtString
    txt.characterStyle.font = app.fonts['Costura']
  