var fountain = {};

(function() {
  var colors, fs, fsu, path, util, yaml,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  path = require("path");

  fs = require("fs");

  util = require("util");

  fsu = require("fs-util");

  fountain.YmlParser = (function() {

    function YmlParser() {}

    YmlParser.parse = function(obj, parent) {
      var child, file, key, relative_path, type, _results;
      if (parent) {
        if (!fs.existsSync(parent)) {
          fsu.mkdir_p(parent);
        }
      }
      _results = [];
      for (key in obj) {
        child = obj[key];
        if (!parent) {
          relative_path = path.resolve(key);
        } else {
          relative_path = path.resolve(parent, key);
        }
        fsu.mkdir_p(relative_path);
        if (child != null ? child.length : void 0) {
          _results.push((function() {
            var _i, _len, _results1;
            _results1 = [];
            for (_i = 0, _len = child.length; _i < _len; _i++) {
              file = child[_i];
              type = typeof file;
              if (type === "object") {
                _results1.push(this.parse(file, relative_path));
              } else {
                _results1.push(fs.writeFileSync("" + relative_path + "/" + file, ""));
              }
            }
            return _results1;
          }).call(YmlParser));
        } else {
          _results.push(YmlParser.parse(child, relative_path));
        }
      }
      return _results;
    };

    return YmlParser;

  }).call(this);

  yaml = require("js-yaml");

  path = require("path");

  fs = require("fs");

  util = require("util");

  colors = require("colors");

  fsu = require("fs-util");

  fountain.Main = (function() {

    Main.prototype.tree = {};

    function Main() {
      this._template_exists = __bind(this._template_exists, this);

      this._get_tmpl_folder = __bind(this._get_tmpl_folder, this);

      this._save_config = __bind(this._save_config, this);

      this._save_folder = __bind(this._save_folder, this);

      this._build = __bind(this._build, this);

      this.list = __bind(this.list, this);

      this.remove = __bind(this.remove, this);

      this.build = __bind(this.build, this);

      this.save = __bind(this.save, this);

    }

    Main.prototype.save = function(path_to_file, name) {
      if (!path_to_file) {
        return console.log("Please, specify a template".red);
      }
      path_to_file = path.resolve(path_to_file);
      if (!fs.existsSync(path_to_file)) {
        return console.log(("Template not found (" + path_to_file + ")").red);
      }
      if (!fs.statSync(path_to_file).isDirectory()) {
        return this._save_config(path_to_file, name);
      } else {
        return this._save_folder(path_to_file, name);
      }
    };

    Main.prototype.build = function(name) {
      var new_tmpl_file;
      if (this._template_exists(name)) {
        new_tmpl_file = path.resolve(this._get_tmpl_folder(name), "" + name + ".yml");
        if (fs.existsSync(new_tmpl_file)) {
          return this._build(new_tmpl_file, name);
        } else {
          fsu.cp_r(this._get_tmpl_folder(name), "" + name);
          return console.log("Successfully builded template!".green);
        }
      } else {
        return console.log("Template not found!".red);
      }
    };

    Main.prototype.remove = function(name) {
      if (this._template_exists(name)) {
        fsu.rm_rf(this._get_tmpl_folder(name));
        return console.log(("Successfully deleted " + name + " template!").green);
      } else {
        return console.log("Template not found!".red);
      }
    };

    Main.prototype.list = function() {
      var name, templates, tmpl_folder, _i, _len, _results;
      tmpl_folder = path.resolve(__dirname, "..", "templates");
      if (fs.existsSync(tmpl_folder)) {
        templates = fsu.ls(tmpl_folder);
        _results = [];
        for (_i = 0, _len = templates.length; _i < _len; _i++) {
          name = templates[_i];
          _results.push(console.log(name.split("/").pop().green));
        }
        return _results;
      } else {
        return console.log("There are no template saved!");
      }
    };

    Main.prototype._build = function(path_to_file, name) {
      var _this = this;
      if (!path_to_file) {
        return console.log("Please, specify a template".red);
      }
      path_to_file = path.resolve(path_to_file);
      if (!fs.existsSync(path_to_file)) {
        return console.log(("Template file not found (" + path_to_file + ")").red);
      }
      return fs.readFile(path_to_file, "utf8", function(err, data) {
        try {
          _this.tree = yaml.load(data);
          fountain.YmlParser.parse(_this.tree, name);
          return console.log("Successfully builded template!".green);
        } catch (e) {
          if (err) {
            return console.log("Error reading the config file".red);
          }
        }
      });
    };

    Main.prototype._save_folder = function(path_to_folder, name) {
      if (!path_to_folder) {
        return console.log("Please, specify a template".red);
      }
      if (!name) {
        return console.log("Please, specify a name: --name <template_name>".red);
      }
      if (this._template_exists(name)) {
        return console.log("Template already exists, choose another name please!".red);
      } else {
        fsu.cp_r(path_to_folder, this._get_tmpl_folder(name));
        return console.log(("Successfully saved " + name + " template!").green);
      }
    };

    Main.prototype._save_config = function(path_to_file, name) {
      var new_tmpl_file;
      if (!path_to_file) {
        return console.log("Please, specify a template".red);
      }
      if (!name) {
        return console.log("Please, specify a name: --name <template_name>".red);
      }
      new_tmpl_file = path.resolve(this._get_tmpl_folder(name), "" + name + ".yml");
      if (fs.existsSync(new_tmpl_file)) {
        return console.log("Template already exists, choose another name please!".red);
      } else {
        if (!fs.existsSync(path_to_file)) {
          return console.log(("Template file not found (" + path_to_file + ")").red);
        }
        fsu.cp_r(path_to_file, new_tmpl_file);
        return console.log(("Successfully saved " + name + " template!").green);
      }
    };

    Main.prototype._get_tmpl_folder = function(name) {
      var new_tmpl_folder, tmpl_folder;
      tmpl_folder = path.resolve(__dirname, "..", "templates");
      if (!fs.existsSync(tmpl_folder)) {
        fsu.mkdir_p(tmpl_folder);
      }
      new_tmpl_folder = path.resolve(tmpl_folder, name);
      if (!fs.existsSync(new_tmpl_folder)) {
        fsu.mkdir_p(new_tmpl_folder);
      }
      return new_tmpl_folder;
    };

    Main.prototype._template_exists = function(name) {
      var new_tmpl_folder, tmpl_folder;
      tmpl_folder = path.resolve(__dirname, "..", "templates");
      new_tmpl_folder = path.resolve(tmpl_folder, name);
      return fs.existsSync(new_tmpl_folder);
    };

    return Main;

  })();

  module.exports = fountain.Main;

}).call(this);
