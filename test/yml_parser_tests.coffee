assert = require "assert"
yaml = require "js-yaml"
path = require "path"
fs = require "fs"
fsu = require "fs-util"
tree = require path.resolve __dirname , "tree"

yaml_parser = require path.resolve __dirname, "../", "src/fountain/yml_parser"

describe "YAML Parser", ->
	it "should return an object reflecting the yaml structure with one level", ()->


		basic_yml = path.resolve __dirname, "_templates", "yaml_configs", "basic.yml"

		basic_yml_data = fs.readFileSync basic_yml, "utf8"
		obj = yaml.load basic_yml_data
		path_to_basic_yml = (path.resolve __dirname, "_results", "yaml_configs", "basic_yml")
		fsu.rm_rf path_to_basic_yml
		yaml_parser.parse obj, path_to_basic_yml
		_result = (tree.tree path_to_basic_yml)

		_template = [{"app":[{"css":["app.css"]},{"js":["app.js"]}]}] 
		assert.deepEqual _result, _template

	it "should return an object reflecting the yaml structure with multiples levels", ()->

		advanced_yml = path.resolve __dirname, "_templates", "yaml_configs", "advanced.yml"

		advanced_yml_data = fs.readFileSync advanced_yml, "utf8"
		obj = yaml.load advanced_yml_data
		path_to_advanced_yml = (path.resolve __dirname, "_results", "yaml_configs", "advanced")
		fsu.rm_rf path_to_advanced_yml if fs.existsSync path_to_advanced_yml
		yaml_parser.parse obj, path_to_advanced_yml
		_result = (tree.tree path_to_advanced_yml)
		_template = [{"app":[{"css":["app.css",{"vendors":[{"vendor_name":["main.css"]},"vendors.css"]}]},{"js":["app.js",{"vendors":["vendors.js"]}]}]}]
		assert.deepEqual _result, _template
