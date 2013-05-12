assert = require "assert"
yaml = require "js-yaml"
path = require "path"
fs = require "fs"
fsu = require "fs-util"
tree = require path.resolve __dirname , "tree"
fountain = require path.resolve __dirname, "../", "src/fountain/main"
yaml_parser = require path.resolve __dirname, "../", "src/fountain/yml_parser"
util = require 'util'

describe "fountain", ->
	
	describe "save", ->
		it "should save a template based on a YAML config", ->

			advanced_yml = path.resolve __dirname, "_templates", "yaml_configs", "advanced.yml"
			path_to_templates = (path.resolve __dirname, "..", "templates")

			path_to_folder = (path.resolve path_to_templates, "test_advanced_yaml")
			fsu.rm_rf path_to_folder if fs.existsSync path_to_folder
			fountain.save advanced_yml, "test_advanced_yaml"

			yml_data = fs.readFileSync (path.resolve path_to_folder, "test_advanced_yaml.yml"), "utf8"
			_result = yaml.load yml_data
			_template = { app: { js: [ 'app.js', { vendors: [ 'vendors.js' ] } ],css: [ 'app.css', { vendors: [ 'vendors.css', { vendor_name: [ 'main.css' ] } ] } ] } }

			fsu.rm_rf path_to_folder if fs.existsSync path_to_folder
			assert.deepEqual _result, _template

		it "should save a template based on a template folder", ->

			template_folder = path.resolve __dirname, "_templates", "fountain", "advanced"
			path_to_template = (path.resolve __dirname, "..", "templates", "test_fountain_advanced")

			fsu.rm_rf path_to_template if fs.existsSync path_to_template
			fountain.save template_folder, "test_fountain_advanced"

			_result = tree.tree path_to_template
			_template = [{"app":[{"css":["app.css",{"vendors":[{"vendor_name":["main.css"]},"vendors.css"]}]},{"js":["app.js",{"vendors":["vendors.js"]}]}]}]

			fsu.rm_rf path_to_template if fs.existsSync path_to_template
			assert.deepEqual _result, _template

	describe "build", ->

		it "should build a template based on a YAML config", ->



