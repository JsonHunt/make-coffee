js2coffee = require 'js2coffee'
path = require 'path'
fs = require 'fs'
S = require 'string'

module.exports = MakeCoffee =

  activate: (state) ->
    atom.commands.add 'atom-workspace', "make-coffee:convert", => @convert()

  deactivate: ->

  serialize: ->

  convert: ->
    try
      treeView = atom.packages.getLoadedPackage('tree-view')
      treeView = require(treeView.mainModulePath)
      packageObj = treeView.serialize()
      source = packageObj.selectedPath
      console.log "Converting #{source} to coffee"
      data = fs.readFileSync source
      try
        result = js2coffee.build data
      catch e
        console.log e.message
        return
      newPath = source.replace '.js', '.coffee'
      console.log "Generating #{newPath}"
      fs.writeFileSync newPath, result.code
      if result.warnings and result.warnings.length > 0
        result.warnings.forEach (warn) -> console.log warn

    catch error
        console.log error.description
        console.log error.stack
