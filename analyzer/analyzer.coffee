fs = require 'fs'

getFiles = (path) ->
  files = []

  search = (path) -> 
    filesAndDirs = fs.readdirSync path

    for file in filesAndDirs
      filePath = path + '/' + file
      stat = fs.statSync(filePath)
      if stat.isDirectory()
        search(filePath)
      else
        files.push(filePath)

  search(path)
  files

analyzejs = (path) ->
  #PATH = '/media/mikhail/New Volume/Projects/Krux/django/shop/ui-components/scripts'

  components = []
  injections = []

  files = getFiles path

  parseFile = (script)->
    REGEXP = /(controller|factory|service|directive|filter)(\([\'\"]\w+[\'\"]\,\s*\w+\))/
    PARAMS_REGEXP = /([^,()\s\'\"]+)/g

    addToInjections = (componentInjections, componentName) ->
      if componentInjections
        injectionsNames = injections.map (element) -> element.name
        for injection in componentInjections
          index = injectionsNames.indexOf(injection)
          if index < 0
            injections.push {name: injection, usagePlaces: [componentName]}
          else
            injections[index].usagePlaces.push componentName

    getLinesCount = (funcSignature) ->
      index = script.indexOf(funcSignature) + funcSignature.length
      openedBlocksCount = -1
      linesCount = -1

      while index isnt script.length
        symbol = script.charAt index

        if symbol is '{'
          if openedBlocksCount < 0 then openedBlocksCount += 2 else openedBlocksCount++
        if symbol is '\n' and openedBlocksCount > 0 then linesCount++
        if symbol is '}' then openedBlocksCount--

        if openedBlocksCount is 0 then break

        index++

      linesCount

    matches = script.match REGEXP
    if matches
      componentParamsSection = matches[2].match PARAMS_REGEXP
      component = {
        name: componentParamsSection[0],
        type: matches[1],
        usagePlaces: []
      }
      components.push component
      funcName = componentParamsSection[1]
      funcRegexpString = 'function\\s*' + funcName + '(\\((\\$*\\w+\\,*\\s*)*\\))'
      funcRegexp = new RegExp funcRegexpString
      func = script.match(funcRegexp) 
      funcSignature = func[0]
      funcParamsSection = script.match(funcRegexp)[1]
      component.linesCount = getLinesCount funcSignature
      addToInjections(funcParamsSection.match(PARAMS_REGEXP), component.name)

  for file in files
    script = fs.readFileSync(file).toString()
    parseFile(script)

  injectionsNames = injections.map (element) -> element.name
  for component in components
    index = injectionsNames.indexOf(component.name)
    if index >= 0
      component.usagePlaces = injections[index].usagePlaces
    
  components.sort (a, b) -> b.linesCount - a.linesCount
    

module.exports.analyzejs = analyzejs


