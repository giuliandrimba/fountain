yaml = require "js-yaml"
path = require "path"
fs = require "fs"
util = require "util"
colors = require "colors"
fsu = require "fs-util"

#<< fountain/yml_parser

class fountain.Main

	tree:{}

	constructor:()->


	build:(path_to_file)=>
		return console.log "Please, specify a template".red unless path_to_file
		path_to_file = path.resolve path_to_file
		return console.log "Template file not found (#{path_to_file})".red unless fs.existsSync path_to_file
		fs.readFile path_to_file, "utf8", (err, data)=>

			try
				@tree = yaml.load data
				fountain.YmlParser.parse @tree
				console.log "Successfully builded template!".green
			catch e
				console.log "Error reading the config file".red if err

	save:(path_to_file, name)=>
		return console.log "Please, specify a template".red unless path_to_file
		path_to_file = path.resolve path_to_file
		return console.log "Template not found (#{path_to_file})".red unless fs.existsSync path_to_file

		unless fs.statSync(path_to_file).isDirectory()
			@_save_config path_to_file, name
		else
			@_save_folder path_to_file, name

	load:(name)=>

		if @_template_exists name

			new_tmpl_file = path.resolve @_get_tmpl_folder(name), "#{name}.yml"

			if fs.existsSync new_tmpl_file
				@build(new_tmpl_file)
			else 
				fsu.cp_r @_get_tmpl_folder(name), "#{name}"
				console.log "Successfully builded template!".green
		else
			console.log "Template not found!".red

	remove:(name)=>
		if @_template_exists name
			fsu.rm_rf @_get_tmpl_folder(name)
			console.log "Successfully deleted #{name} template!".green
		else
			console.log "Template not found!".red

	########## private methods

	_save_folder:(path_to_folder, name)=>
		return console.log "Please, specify a template".red unless path_to_folder

		if @_template_exists(name)
			console.log "Template already exists, choose another name please!".red
		else
			fsu.cp_r path_to_folder, @_get_tmpl_folder(name)
			console.log "Successfully saved #{name} template!".green
			

	_save_config:(path_to_file, name)=>

		new_tmpl_file = path.resolve @_get_tmpl_folder(name), "#{name}.yml"

		if fs.existsSync new_tmpl_file
			console.log "Template already exists, choose another name please!".red
		else
			return console.log "Template file not found (#{path_to_file})".red unless fs.existsSync path_to_file
			fsu.cp_r path_to_file, new_tmpl_file
			console.log "Successfully saved #{name} template!".green

	_get_tmpl_folder:(name)=>
		tmpl_folder = path.resolve __dirname, "..", "templates"
		fsu.mkdir_p tmpl_folder unless fs.existsSync tmpl_folder

		new_tmpl_folder = path.resolve tmpl_folder, name
		fsu.mkdir_p new_tmpl_folder unless fs.existsSync new_tmpl_folder

		new_tmpl_folder

	_template_exists:(name)=>
		tmpl_folder = path.resolve __dirname, "..", "templates"
		new_tmpl_folder = path.resolve tmpl_folder, name
		fs.existsSync new_tmpl_folder

module.exports = fountain.Main