yaml = require "js-yaml"
path = require "path"
fs = require "fs"
wrench = require "wrench"
util = require "util"


class fountain.Main

	tree:{}

	constructor:()->
		@config_path = path.resolve "fountain.yml"

	build:()=>
		fs.readFile @config_path, "utf8", (err, data)=>

			console.log "Error reading the config file" if err

			try
				@tree = yaml.load data
				@_get_children @tree
			catch e
				console.log e


	save:(name)=>
		tmpl_folder = path.resolve __dirname, "..", "templates"
		wrench.mkdirSyncRecursive tmpl_folder unless fs.existsSync tmpl_folder
		new_tmpl_file = path.resolve tmpl_folder, "#{name}.yml"

		if fs.existsSync new_tmpl_file
			console.log "template already exists, choose another name please!"
		else
			@_copyFileSync @config_path, new_tmpl_file
			console.log "successfully saved #{name} template"


	load:(name)=>
		tmpl_folder = path.resolve __dirname, "..", "templates"
		wrench.mkdirSyncRecursive tmpl_folder unless fs.existsSync tmpl_folder
		new_tmpl_file = path.resolve tmpl_folder, "#{name}.yml"

		if fs.existsSync new_tmpl_file
			@config_path = new_tmpl_file
			@build()
			console.log "successfully builded template"
		else
			console.log "template not found"

	remove:(name)=>
		tmpl_folder = path.resolve __dirname, "..", "templates"
		wrench.mkdirSyncRecursive tmpl_folder unless fs.existsSync tmpl_folder
		new_tmpl_file = path.resolve tmpl_folder, "#{name}.yml"

		if fs.existsSync new_tmpl_file
			fs.unlinkSync new_tmpl_file
			console.log "successfully deleted #{name} template"
		else
			console.log "template not found"
		
	_get_children:(obj, parent)=>

		if parent
			wrench.mkdirSyncRecursive parent unless fs.existsSync parent

		for key of obj
			child = obj[key]
			unless parent
				relative_path = path.resolve key
			else
				relative_path = path.resolve parent, key

			wrench.mkdirSyncRecursive relative_path

			if child?.length
				for file in child

					type = typeof file

					if type is "object"
						@_get_children file, relative_path
					else
						fs.writeFileSync "#{relative_path}/#{file}", ""
			else
				@_get_children child, relative_path

	_copyFileSync : (srcFile, destFile) ->
		console.log srcFile
		BUF_LENGTH = 64*1024
		buff = new Buffer(BUF_LENGTH)
		fdr = fs.openSync(srcFile, 'r')
		fdw = fs.openSync(destFile, 'w')
		bytesRead = 1
		pos = 0
		while bytesRead > 0
			bytesRead = fs.readSync(fdr, buff, 0, BUF_LENGTH, pos)
			fs.writeSync(fdw,buff,0,bytesRead)
			pos += bytesRead
		fs.closeSync(fdr)
		fs.closeSync(fdw)

module.exports = fountain.Main