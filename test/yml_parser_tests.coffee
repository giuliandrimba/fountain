assert = require "assert"
yaml = require "js-yaml"
path = require "path"
yaml_parser = require path.resolve __dirname, "../", "src/fountain/yml_parser"

describe "YAML Parser", ->
	it "should return an object reflecting the yaml structure", ->
		basic_yml = path.resolve __dirname, "yaml_configs", "fountain.yml"
		basic = yaml.load basic_yml
		fountain.yaml_parser.parse @tree, name
		console.log basic
		assert.equal true, true
		