assert = require "assert"
yaml = require "js-yaml"
path = require "path"
fs = require "fs"
fsu = require "fs-util"
tree = require path.resolve __dirname , "tree"
fountain = require path.resolve __dirname, "../", "src/fountain/main"
yaml_parser = require path.resolve __dirname, "../", "src/fountain/yml_parser"
util = require 'util'

describe "Fountain", ->

	templates_folder =  (path.resolve __dirname, "..", "templates")
	template_folder_config = [{"app":[{"css":["app.css",{"vendors":[{"vendor_name":["main.css"]},"vendors.css"]}]},{"js":["app.js",{"vendors":["vendors.js"]}]}]}]

	describe "save", ->
		it "should save a template based on a YAML config", ->

			template_name = "test_advanced_yaml"
			advanced_yml = path.resolve __dirname, "_templates", "yaml_configs", "advanced.yml"

			path_to_folder = (path.resolve templates_folder, template_name)
			fountain.save advanced_yml, template_name

			yml_data = fs.readFileSync (path.resolve path_to_folder, "#{template_name}.yml"), "utf8"
			_result = yaml.load yml_data
			_template = { app: { js: [ 'app.js', { vendors: [ 'vendors.js' ] } ],css: [ 'app.css', { vendors: [ 'vendors.css', { vendor_name: [ 'main.css' ] } ] } ] } }

			assert.deepEqual _result, _template

		it "should save a template based on a template folder", ->

			template_name = "test_fountain_advanced"
			template_folder = path.resolve __dirname, "_templates", "fountain", "advanced"
			path_to_template = (path.resolve templates_folder, template_name)

			fountain.save template_folder, template_name

			_result = tree.tree path_to_template

			assert.deepEqual _result, template_folder_config

	describe "remove", ->

		it "should remove a template folder", ->

			template_name = "test_fountain_advanced"
			template_folder = (path.resolve templates_folder, template_name)
			fountain.remove template_name

			removed = fs.existsSync template_folder

			assert.equal removed, false

		it "should remove a YAML template folder", ->

			template_name = "test_advanced_yaml"
			template_folder = (path.resolve templates_folder, template_name)
			fountain.remove template_name

			removed = fs.existsSync template_folder

			assert.equal removed, false

	describe "build", ->

		it "should build a template", ->

			name = "test_advanced_yaml"

			template_folder = path.resolve __dirname, "_templates", "fountain" ,"advanced"
			result_folder = path.resolve __dirname, "..", name

			fountain.save template_folder, name
			fountain.build name
			_result = (tree.tree result_folder)

			fsu.rm_rf result_folder if fs.existsSync result_folder
			fountain.remove name
			assert.deepEqual _result, template_folder_config

	describe "list", ->

		it "should list all the templates", ->

			_list = fountain.list()
			_result = fsu.ls templates_folder
			
			assert.equal _result.length, _list.length
