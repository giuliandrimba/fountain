var fountain = {};

(function() {
  var fs, path, util, wrench, yaml,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  yaml = require("js-yaml");

  path = require("path");

  fs = require("fs");

  wrench = require("wrench");

  util = require("util");

  fountain.Main = (function() {

    Main.prototype.tree = {};

    function Main() {
      this._get_children = __bind(this._get_children, this);

      this.remove = __bind(this.remove, this);

      this.load = __bind(this.load, this);

      this.save = __bind(this.save, this);

      this.build = __bind(this.build, this);
      this.config_path = path.resolve("fountain.yml");
    }

    Main.prototype.build = function() {
      var _this = this;
      return fs.readFile(this.config_path, "utf8", function(err, data) {
        if (err) {
          console.log("Error reading the config file");
        }
        try {
          _this.tree = yaml.load(data);
          return _this._get_children(_this.tree);
        } catch (e) {
          return console.log(e);
        }
      });
    };

    Main.prototype.save = function(name) {
      var new_tmpl_file, tmpl_folder;
      tmpl_folder = path.resolve(__dirname, "..", "templates");
      if (!fs.existsSync(tmpl_folder)) {
        wrench.mkdirSyncRecursive(tmpl_folder);
      }
      new_tmpl_file = path.resolve(tmpl_folder, "" + name + ".yml");
      if (fs.existsSync(new_tmpl_file)) {
        return console.log("template already exists, choose another name please!");
      } else {
        this._copyFileSync(this.config_path, new_tmpl_file);
        return console.log("successfully saved " + name + " template");
      }
    };

    Main.prototype.load = function(name) {
      var new_tmpl_file, tmpl_folder;
      tmpl_folder = path.resolve(__dirname, "..", "templates");
      if (!fs.existsSync(tmpl_folder)) {
        wrench.mkdirSyncRecursive(tmpl_folder);
      }
      new_tmpl_file = path.resolve(tmpl_folder, "" + name + ".yml");
      if (fs.existsSync(new_tmpl_file)) {
        this.config_path = new_tmpl_file;
        this.build();
        return console.log("successfully builded template");
      } else {
        return console.log("template not found");
      }
    };

    Main.prototype.remove = function(name) {
      var new_tmpl_file, tmpl_folder;
      tmpl_folder = path.resolve(__dirname, "..", "templates");
      if (!fs.existsSync(tmpl_folder)) {
        wrench.mkdirSyncRecursive(tmpl_folder);
      }
      new_tmpl_file = path.resolve(tmpl_folder, "" + name + ".yml");
      if (fs.existsSync(new_tmpl_file)) {
        fs.unlinkSync(new_tmpl_file);
        return console.log("successfully deleted " + name + " template");
      } else {
        return console.log("template not found");
      }
    };

    Main.prototype._get_children = function(obj, parent) {
      var child, file, key, relative_path, type, _results;
      if (parent) {
        if (!fs.existsSync(parent)) {
          wrench.mkdirSyncRecursive(parent);
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
        wrench.mkdirSyncRecursive(relative_path);
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

    Main.prototype._copyFileSync = function(srcFile, destFile) {
      var BUF_LENGTH, buff, bytesRead, fdr, fdw, pos;
      console.log(srcFile);
      BUF_LENGTH = 64 * 1024;
      buff = new Buffer(BUF_LENGTH);
      fdr = fs.openSync(srcFile, 'r');
      fdw = fs.openSync(destFile, 'w');
      bytesRead = 1;
      pos = 0;
      while (bytesRead > 0) {
        bytesRead = fs.readSync(fdr, buff, 0, BUF_LENGTH, pos);
        fs.writeSync(fdw, buff, 0, bytesRead);
        pos += bytesRead;
      }
      fs.closeSync(fdr);
      return fs.closeSync(fdw);
    };

    return Main;

  })();

  module.exports = fountain.Main;

}).call(this);