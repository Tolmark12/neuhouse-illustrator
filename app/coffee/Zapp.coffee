class Main

  constructor: () ->
    @uiPallete = new UIPalette @onGenerateFontClick, @onMakeFontClick
  
  onGenerateFontClick : (txt, size, destination, font) =>
    @fileGenerator = new LetterFileGenerator destination 
    @fileGenerator.generateLetterLayers txt, size, font
  
  onMakeFontClick : (destination, font) ->
    @fileGenerator = new LetterFileGenerator destination 
    @fileGenerator.generateSVG font
  

new Main()