var fountain = {'utils':{}};

(function() {
  var colors, fs, fsu, path, util, yaml,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  yaml = require("js-yaml");

  path = require("path");

  fs = require("fs");

  util = require("util");

  colors = require("colors");

  fsu = require("fs-util");

  fountain.Main = (function() {

    Main.prototype.tree = {};

    function Main() {
      this._get_children = __bind(this._get_children, this);

      this.remove = __bind(this.remove, this);

      this.load = __bind(this.load, this);

      this._save_config = __bind(this._save_config, this);

      this._get_tmpl_folder = __bind(this._get_tmpl_folder, this);

      this.save = __bind(this.save, this);

      this.build = __bind(this.build, this);
      this.config_path = path.resolve("fountain.yml");
    }

    Main.prototype.build = function() {
      var _this = this;
      if (!fs.existsSync(this.config_path)) {
        return console.log("Template file not found (fountain.yml)".red);
      }
      return fs.readFile(this.config_path, "utf8", function(err, data) {
        try {
          _this.tree = yaml.load(data);
          _this._get_children(_this.tree);
          return console.log("Successfully builded template!".green);
        } catch (e) {
          if (err) {
            return console.log("Error reading the config file".red);
          }
        }
      });
    };

    Main.prototype.save = function(name) {
      return this._save_config(name);
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

    Main.prototype._save_config = function(name) {
      var new_tmpl_file;
      new_tmpl_file = path.resolve(this._get_tmpl_folder(name), "" + name + ".yml");
      if (fs.existsSync(new_tmpl_file)) {
        return console.log("Template already exists, choose another name please!".red);
      } else {
        if (!fs.existsSync(this.config_path)) {
          return console.log("Template file not found (fountain.yml)".red);
        }
        fsu.cp_r(this.config_path, new_tmpl_file);
        return console.log(("Successfully saved " + name + " template!").green);
      }
    };

    Main.prototype.load = function(name) {
      var new_tmpl_file;
      new_tmpl_file = path.resolve(this._get_tmpl_folder(name), "" + name + ".yml");
      if (fs.existsSync(new_tmpl_file)) {
        this.config_path = new_tmpl_file;
        return this.build();
      } else {
        return console.log("Template not found!".red);
      }
    };

    Main.prototype.remove = function(name) {
      if (fs.existsSync(this._get_tmpl_folder(name))) {
        fsu.rm_rf(this._get_tmpl_folder(name));
        return console.log(("Successfully deleted " + name + " template!").green);
      } else {
        return console.log("Template not found!".red);
      }
    };

    Main.prototype._get_children = function(obj, parent) {
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
                _results1.push(this._get_children(file, relative_path));
              } else {
                _results1.push(fs.writeFileSync("" + relative_path + "/" + file, ""));
              }
            }
            return _results1;
          }).call(this));
        } else {
          _results.push(this._get_children(child, relative_path));
        }
      }
      return _results;
    };

    return Main;

  })();

  module.exports = fountain.Main;

}).call(this);
