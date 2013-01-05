# Fountain V0.2.1

## Scaffolding tool using a YAML file as folder structure, or a template folder

### Usage:
+ *fountain save (-s) <path_to_file/path_to_folder> --name <name>:* Save the template passing the path to the YAML file, or a folder template
+ *fountain load (-l) <name>:* Load the template by name, and build it;
+ *fountain remove (-r) <name>:* Remove the template by name;
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
<pre>fountain load test</pre>