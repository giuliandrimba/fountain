yaml = require "js-yaml"
path = require "path"
fs = require "fs"
wrench = require "wrench"
util = require "util"
colors = require "colors"


class fountain.Main

	tree:{}

	constructor:()->
		@config_path = path.resolve "fountain.yml"

	build:()=>
		return console.log "Template file not found (fountain.yml)".red unless fs.existsSync @config_path
		fs.readFile @config_path, "utf8", (err, data)=>

			try
				@tree = yaml.load data
				@_get_children @tree
				console.log "Successfully builded template!".green
			catch e
				console.log "Error reading the config file".red if err
				# console.log e


	save:(name)=>
		tmpl_folder = path.resolve __dirname, "..", "templates"
		wrench.mkdirSyncRecursive tmpl_folder unless fs.existsSync tmpl_folder
		new_tmpl_file = path.resolve tmpl_folder, "#{name}.yml"

		if fs.existsSync new_tmpl_file
			console.log "Template already exists, choose another name please!".red
		else
			@_copyFileSync @config_path, new_tmpl_file
			console.log "Successfully saved #{name} template!".green


	load:(name)=>
		tmpl_folder = path.resolve __dirname, "..", "templates"
		wrench.mkdirSyncRecursive tmpl_folder unless fs.existsSync tmpl_folder
		new_tmpl_file = path.resolve tmpl_folder, "#{name}.yml"

		if fs.existsSync new_tmpl_file
			@config_path = new_tmpl_file
			@build()
		else
			console.log "Template not found!".red

	remove:(name)=>
		tmpl_folder = path.resolve __dirname, "..", "templates"
		wrench.mkdirSyncRecursive tmpl_folder unless fs.existsSync tmpl_folder
		new_tmpl_file = path.resolve tmpl_folder, "#{name}.yml"

		if fs.existsSync new_tmpl_file
			fs.unlinkSync new_tmpl_file
			console.log "Successfully deleted #{name} template!".green
		else
			console.log "Template not found!".red
		
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