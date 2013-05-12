fs = require "fs"
path = require "path"

exports.tree = tree = (folder)->
	obj = []
	for file,i in fs.readdirSync folder
		file_path = path.resolve folder, file
		if (fs.statSync(file_path).isDirectory())
			dir = {}
			dir[file] = tree file_path
			obj[i] = dir
		else
			obj[i] = file
	obj