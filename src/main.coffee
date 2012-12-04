yaml = require "js-yaml"
path = require "path"
fs = require "fs"
wrench = require "wrench"
util = require "util"

class Main

	tree:{}

	constructor:()->
		config_path = path.resolve __dirname, "../test/config.yml"

		fs.readFile config_path, "utf8", (err, data)=>

			console.log "Error reading the config file" if err

			try
				@tree = yaml.load data
				@build()
			catch e
				console.log e

	build:=>
		@_get_children @tree, "dest"

	_get_children:(obj, parent)=>

		wrench.mkdirSyncRecursive parent unless fs.existsSync parent

		for key, val of obj
			child = obj[key]
			relative_path = path.resolve parent, key

			wrench.mkdirSyncRecursive relative_path

			if child.length
				for file in child
					fs.writeFileSync "#{relative_path}/#{file}"
			else
				@_get_children child, relative_path unless child.length


new Main