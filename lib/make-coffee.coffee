js2coffee = require 'js2coffee'
path = require 'path'
fs = require 'fs'
S = require 'string'
MyPanel = require './panel'
MyRenamePanel = require './rename-panel'
{CompositeDisposable} = require 'atom'

module.exports = MakeCoffee =

	activate: (state) ->
		@subscriptions = new CompositeDisposable
		@subscriptions.add atom.commands.add 'atom-workspace',
			"make-coffee:convert": => @convert()
			"make-coffee:component": => @createComponent()
			"make-coffee:rename_component": => @renameComponent()
			"core:cancel": => @destroyPanel()
			"core:confirm": => @destroyPanel()


	deactivate: ->

	serialize: ->

	destroyPanel: ->
		if @epanel
			@epanel.destroy()

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



	createComponent: ->
		try
			treeView = atom.packages.getLoadedPackage('tree-view')
			treeView = require(treeView.mainModulePath)
			packageObj = treeView.serialize()
			source = packageObj.selectedPath
			console.log "Passing in start value #{source}"

			@epanel = atom.workspace.addTopPanel(
				item: new MyPanel(source)
				visible: true
				priority: 100
			)

			# @epanel.item.findEditor.setText(source + path.sep)
			@epanel.item.findEditor.focus()

		catch error
				console.log error.description
				console.log error.stack

	doCreate: (element)=>
		console.log "Creating folder #{element.value}"
		# console.log "Creating #{source}"
		# data = fs.readFileSync source
		# try
		#   result = js2coffee.build data
		# catch e
		#   console.log e.message
		#   return
		# newPath = source.replace '.js', '.coffee'
		# console.log "Generating #{newPath}"
		# fs.writeFileSync newPath, result.code
		# if result.warnings and result.warnings.length > 0
		#   result.warnings.forEach (warn) -> console.log warn

	renameComponent: ->
		try
			treeView = atom.packages.getLoadedPackage('tree-view')
			treeView = require(treeView.mainModulePath)
			packageObj = treeView.serialize()
			source = packageObj.selectedPath
			console.log "Passing in start value #{source}"

			@epanel = atom.workspace.addTopPanel(
				item: new MyRenamePanel(source)
				visible: true
				priority: 100
			)

			# @epanel.item.findEditor.setText(source + path.sep)
			@epanel.item.findEditor.focus()

		catch error
				console.log error.description
				console.log error.stack
