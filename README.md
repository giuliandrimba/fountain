# Fountain v0.3.2

## Scaffolding tool using a YAML file as folder structure, or a template folder

## Description:
Use __fountain__ to create custom scaffolding builds. 
You can create the structure of your template using a YAML file, save it and build it (folder and files will be generated based on it), or you can create your template folder and save it for further use.

### Instalation:
<pre>npm install -g fountain </pre>

### Usage:
+ *fountain save (-s) <path_to_file/path_to_folder> --name <name>:* Save the template passing the path to the YAML file, or a folder template
+ *fountain build (-b) <name>:* Build the template by name;
+ *fountain remove (-r) <name>:* Remove the template by name;
+ *fountain list (-l) <name>:* List all the templates;
+ *fountain version (-v):* Show version;
+ *fountain help (-h):* Show help;

### YAML file example:

````bash
app
  - js:
    - app.js
  - css:
    - app.css
````

### Example using this template:
<pre>fountain build test</pre>
