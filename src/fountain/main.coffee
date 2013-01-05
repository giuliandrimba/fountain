yaml = require "js-yaml"
path = require "path"
fs = require "fs"
util = require "util"
colors = require "colors"
fsu = require "fs-util"


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


	save:(name)=>
		@_save_config name

	_get_tmpl_folder:(name)=>
		tmpl_folder = path.resolve __dirname, "..", "templates"
		fsu.mkdir_p tmpl_folder unless fs.existsSync tmpl_folder

		new_tmpl_folder = path.resolve tmpl_folder, name
		fsu.mkdir_p new_tmpl_folder unless fs.existsSync new_tmpl_folder

		new_tmpl_folder

	_save_config:(name)=>

		new_tmpl_file = path.resolve @_get_tmpl_folder(name), "#{name}.yml"

		if fs.existsSync new_tmpl_file
			console.log "Template already exists, choose another name please!".red
		else
			return console.log "Template file not found (fountain.yml)".red unless fs.existsSync @config_path
			fsu.cp_r @config_path, new_tmpl_file
			console.log "Successfully saved #{name} template!".green

	load:(name)=>
		new_tmpl_file = path.resolve @_get_tmpl_folder(name), "#{name}.yml"

		if fs.existsSync new_tmpl_file
			@config_path = new_tmpl_file
			@build()
		else
			console.log "Template not found!".red

	remove:(name)=>
		if fs.existsSync @_get_tmpl_folder(name)
			fsu.rm_rf @_get_tmpl_folder(name)
			console.log "Successfully deleted #{name} template!".green
		else
			console.log "Template not found!".red
		
	_get_children:(obj, parent)=>

		if parent
			fsu.mkdir_p parent unless fs.existsSync parent

		for key of obj
			child = obj[key]
			unless parent
				relative_path = path.resolve key
			else
				relative_path = path.resolve parent, key

			fsu.mkdir_p relative_path

			if child?.length
				for file in child

					type = typeof file

					if type is "object"
						@_get_children file, relative_path
					else
						fs.writeFileSync "#{relative_path}/#{file}", ""
			else
				@_get_children child, relative_path

module.exports = fountain.Main