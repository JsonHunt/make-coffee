{$$$, View, TextEditorView} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'
fs = require 'fs'
path = require 'path'

module.exports =
class FindView extends View
	@content: ()->
		@div tabIndex: -1, class: 'panel-top', =>
			@div class: 'editor-container', =>
				@subview 'findEditor', new TextEditorView(mini: true, placeholderText: 'Module Name')

	initialize: (modulePath) ->
		@subscriptions = new CompositeDisposable
		@subscriptions.add atom.commands.add @findEditor.element,
			'core:confirm': =>
				moduleName = @findEditor.getText()
				parent = path.dirname modulePath
				newModulePath = path.join parent, moduleName
				fs.rename modulePath, newModulePath, (err)->
					fs.readdir newModulePath, (err,files)->
						for file in files
							oldFile = path.join newModulePath, file
							ext = path.extname file
							newFile = path.join newModulePath, "#{moduleName}#{ext}"
							fs.rename oldFile, newFile, (err)-> console.log err if err

	destroy: ->
		@subscriptions?.dispose()
		# @findEditor.on 'core:confirm', => console.log @findEditor.getText()
