path = require "path"
fs = require "fs"
util = require "util"
fsu = require "fs-util"

class YmlParser

	constructor:()->

	parse:(obj, parent)=>
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
						@parse file, relative_path
					else
						fs.writeFileSync "#{relative_path}/#{file}", ""
			else
				@parse child, relative_path
		
module.exports = new YmlParser