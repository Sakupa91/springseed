$ ->
	node = false

	# Node Webkit Stuff
	try
		gui = require 'nw.gui'
		fs = require 'fs'
		path = require 'path'

		# Show Window
		win = gui.Window.get()
		win.show()
		win.showDevTools()

		# Panel Controls
		$('#close').click ->
			win.close()
		$('#minimize').click ->
			win.minimize()
		$('#maximize').click ->
			win.maximize()

		# Panel Dragging
		$('#panel').mouseenter ->
			$('#panel').addClass('drag')
		$('#panel #decor img, #panel #noteControls img, #panel #search').mouseenter ->
			$('#panel').removeClass('drag')
		$('#panel #decor img, #panel #noteControls img, #panel #search').mouseleave ->
			$('#panel').addClass('drag')
		$('#panel').mouseleave ->
			$('#panel').removeClass('drag')

		# OS Detection
		OSName = "Unknown OS"
		OSName = "Windows"  unless navigator.appVersion.indexOf("Win") is -1
		OSName = "Mac"  unless navigator.appVersion.indexOf("Mac") is -1
		OSName = "UNIX"  unless navigator.appVersion.indexOf("X11") is -1
		OSName = "Linux"  unless navigator.appVersion.indexOf("Linux") is -1

		node = true
		storage_dir = process.env.HOME
	catch e
		console.log("We're not running under node-webkit.")

	# Set Up Storage Stuffs
	# if OSName is "Mac"
	# 	fs.mkdir(path.join(storage_dir, "/Library/Application Support/Noted/")


	# Event Handlers
	$("#content header .edit").click ->

		# There should be a better way to do this
		if $(this).text() is "save"
			$(this).text "edit"
			window.noted.editor.preview()
		else
			$(this).text "save"
			window.noted.editor.edit()

	# Create Markdown Editor
	window.noted.editor = new EpicEditor
		container: 'contentbody'
		theme:
    		base:'/themes/base/epiceditor.css'
    		preview:'/themes/preview/style.css'
		    editor:'/themes/editor/style.css'

	window.noted.editor.load()

	if node
		fs.readFile path.join(storage_dir, 'file.txt'), 'utf-8', (err, data) ->
			throw err if (err)
			window.noted.editor.importFile('file', data)
			window.noted.editor.preview()
	else
		window.noted.editor.importFile('file', "Not running under node webkit")
		window.noted.editor.preview()

window.noted = {}