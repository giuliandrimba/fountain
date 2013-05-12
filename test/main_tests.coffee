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

	describe "save", ->
		it "should save a template based on a YAML config", ->

			advanced_yml = path.resolve __dirname, "_templates", "yaml_configs", "advanced.yml"
			path_to_templates = (path.resolve __dirname, "..", "templates")

			path_to_folder = (path.resolve path_to_templates, "test_advanced_yaml")
			fountain.save advanced_yml, "test_advanced_yaml"

			yml_data = fs.readFileSync (path.resolve path_to_folder, "test_advanced_yaml.yml"), "utf8"
			_result = yaml.load yml_data
			_template = { app: { js: [ 'app.js', { vendors: [ 'vendors.js' ] } ],css: [ 'app.css', { vendors: [ 'vendors.css', { vendor_name: [ 'main.css' ] } ] } ] } }

			assert.deepEqual _result, _template

		it "should save a template based on a template folder", ->

			template_folder = path.resolve __dirname, "_templates", "fountain", "advanced"
			path_to_template = (path.resolve __dirname, "..", "templates", "test_fountain_advanced")

			fountain.save template_folder, "test_fountain_advanced"

			_result = tree.tree path_to_template
			_template = [{"app":[{"css":["app.css",{"vendors":[{"vendor_name":["main.css"]},"vendors.css"]}]},{"js":["app.js",{"vendors":["vendors.js"]}]}]}]

			assert.deepEqual _result, _template

	describe "remove", ->

		it "should remove a template folder", ->

			name = "test_fountain_advanced"
			template_folder = (path.resolve __dirname, "..", "templates", name)
			fountain.remove "test_fountain_advanced"

			removed = fs.existsSync template_folder

			assert.equal removed, false

		it "should remove a YAML template folder", ->

			name = "test_advanced_yaml"
			template_folder = (path.resolve __dirname, "..", "templates", name)
			fountain.remove "test_advanced_yaml"

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
			_template = [{"app":[{"css":["app.css",{"vendors":[{"vendor_name":["main.css"]},"vendors.css"]}]},{"js":["app.js",{"vendors":["vendors.js"]}]}]}]

			fsu.rm_rf result_folder if fs.existsSync result_folder
			fountain.remove name
			assert.deepEqual _result, _template

	describe "list", ->

		it "should list all the templates", ->

			template_folder = (path.resolve __dirname, "..", "templates")
			_list = fountain.list()
			_result = fsu.ls template_folder
			
			assert.equal _result.length, _list.length
