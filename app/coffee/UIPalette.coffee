class UIPalette

  constructor: (@onGenerateFontClick, @makeFont) ->
    structure = 
      directory:
        type: 'text'
        value: ''
        fullSize:true
      pickFolderBtn: 
        type: 'button', 
        value:'Choose Destination Folder'
        fullSize:true
        onClick: @onChooseFolderClick
      ruleA:
        type: 'ruler'
        fullSize:true
      text:
        type: 'string'
        label: 'Text'
      size:
        type: 'list', 
        label: 'Inches', 
        options: [5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]
      ruleB:
        type: 'ruler'
        fullSize:true
      font : 
        type:'font'
        label:'Font'
        fullSize:true
      generateBtn: 
        type:'button', 
        value:'Generate Letters'
        onClick: @onGenerateClick
        fullSize:true
      ruleC:
        type: 'ruler'
        fullSize:true
      makeFont: 
        type:'button', 
        value:'Generate Letters'
        onClick: @onMakeFontClick
        fullSize:true

    @vals = 
      font:'Helvetica Neue Bold'
      directory:'/Users/Mark'
      text:'ZATBXO0C'
      size:structure.size.options[0]

    @pallete = new Palette('Neuhouse', structure, @vals)
  

  onChooseFolderClick : () =>
    @destinationFolder = Dialog.chooseDirectory("message")
    @vals.text = String( @destinationFolder )

  onGenerateClick : () => 
    # Extract font name
    fullName = String(@vals.font)
    weight   = String(@vals.font.name)
    fontName = fullName.replace " #{weight}", ""
    fontRef  = app.fonts[ fontName ][ weight]

    # Text and Size
    txt      = @vals.text
    size     = @vals.size
    @onGenerateFontClick txt, size, @vals.directory, fontRef
  
  onMakeFontClick : () => 
    # Extract font name
    fullName = String(@vals.font)
    weight   = String(@vals.font.name)
    fontName = fullName.replace " #{weight}", ""
    fontRef  = app.fonts[ fontName ][ weight]

    # Text and Size
    txt      = @vals.text
    size     = @vals.size

    @makeFont @vals.directory, fontRef
    
  
