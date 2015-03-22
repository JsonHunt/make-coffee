{$$$, View, TextEditorView} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'
fs = require 'fs'

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
				console.log "Creating folder #{modulePath}\\#{moduleName}"
				fs.mkdir "#{modulePath}\\#{moduleName}", (err)->
					filename = "#{modulePath}\\#{moduleName}\\#{moduleName}"
					fs.writeFile "#{filename}.coffee",'',  (err)->
						console.log "Coffee created"
						fs.writeFile "#{filename}.jade",'', (err)->
							console.log "Jade created"
							fs.writeFile "#{filename}.styl",'', (err)->
								console.log "Stylus created"
								atom.workspace.open "#{filename}.jade"




	destroy: ->
		@subscriptions?.dispose()
		# @findEditor.on 'core:confirm', => console.log @findEditor.getText()
