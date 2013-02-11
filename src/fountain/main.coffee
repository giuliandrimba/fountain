yaml = require "js-yaml"
path = require "path"
fs = require "fs"
util = require "util"
colors = require "colors"
fsu = require "fs-util"
yaml_parser = require path.resolve __dirname , "yml_parser"


class Main

	tree:{}

	constructor:()->	
		

	save:(path_to_file, name)=>
		return console.log "Please, specify a template".red unless path_to_file
		path_to_file = path.resolve path_to_file
		return console.log "Template not found (#{path_to_file})".red unless fs.existsSync path_to_file

		unless fs.statSync(path_to_file).isDirectory()
			@_save_config path_to_file, name
		else
			@_save_folder path_to_file, name

	build:(name)=>

		if @_template_exists name

			new_tmpl_file = path.resolve @_get_tmpl_folder(name), "#{name}.yml"

			if fs.existsSync new_tmpl_file
				@_build new_tmpl_file, name
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

	list:=>
		tmpl_folder = path.resolve __dirname, "..", "templates"
		if fs.existsSync tmpl_folder
			templates = fsu.ls tmpl_folder
			console.log name.split("/").pop().green for name in templates
		else
			console.log "There are no template saved!"

	########## private methods

	_build:(path_to_file, name)=>
		return console.log "Please, specify a template".red unless path_to_file
		path_to_file = path.resolve path_to_file
		return console.log "Template file not found (#{path_to_file})".red unless fs.existsSync path_to_file
		fs.readFile path_to_file, "utf8", (err, data)=>

			try
				@tree = yaml.load data
				yaml_parser.parse @tree, name
				console.log "Successfully builded template!".green
			catch e
				console.log "Error reading the config file".red if err

	_save_folder:(path_to_folder, name)=>
		return console.log "Please, specify a template".red unless path_to_folder
		return console.log "Please, specify a name: --name <template_name>".red unless name

		if @_template_exists(name)
			console.log "Template already exists, choose another name please!".red
		else
			fsu.cp_r path_to_folder, @_get_tmpl_folder(name)
			console.log "Successfully saved #{name} template!".green
			

	_save_config:(path_to_file, name)=>
		return console.log "Please, specify a template".red unless path_to_file
		return console.log "Please, specify a name: --name <template_name>".red unless name
		new_tmpl_file = path.resolve @_get_tmpl_folder(name), "#{name}.yml"

		if fs.existsSync new_tmpl_file
			console.log "Template already exists, choose another name please!".red
		else
			return console.log "Template file not found (#{path_to_file})".red unless fs.existsSync path_to_file
			fsu.cp path_to_file, new_tmpl_file
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

module.exports = new Main