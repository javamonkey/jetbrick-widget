###---------------------------------------------------------
 * summary:
 *		Performs parameterized substitutions on a string. Throws an
 *		exception if any parameter is unmatched.
 * template:
 *		a string with expressions in the form `{key}` to be replaced.
 *      keys are case-sensitive.
 * data:
 *		hash to search for substitutions
 * transform:
 *		a function to process all parameters before substitution takes
 *		place, e.g. mylib.encodeXML
 * example:
 *		Substitutes two expressions in a string from an Array or Object
 *	|	// returns "File 'foo.html' is not found in directory '/temp'."
 *	|	// by providing substitution data in an Array
 *	|	string.substitute(
 *	|		"File '{[0]}' is not found in directory '{[1]}'.",
 *	|		["foo.html","/temp"]
 *	|	);
 *	|
 *	|	// also returns "File 'foo.html' is not found in directory '/temp'."
 *	|	// but provides substitution data in an Object structure.  Dotted
 *	|	// notation may be used to traverse the structure.
 *	|	string.substitute(
 *	|		"File '{name}' is not found in directory '{info.dir}'.",
 *	|		{ name: "foo.html", info: { dir: "/temp" } }
 *	|	);
 * example:
 *		Use a transform function to modify the values:
 *	|	// returns "file 'foo.html' is not found in directory '/temp'."
 *	|	string.substitute(
 *	|		"{data[0]} is not found in {data[1].info.dir}.",
 *	|		{ data: ["foo.html", info: { dir: "/temp" }] },
 *	|		function(str){
 *	|			// try to figure out the type
 *	|			var prefix = (str.charAt(0) == "/") ? "directory": "file";
 *	|			return prefix + " '" + str + "'";
 *	|		}
 *	|	);
 --------------------------------------------------------###
jetbrick.substitute = (template, data, transform) ->
  regex = /\{([^{}]+)\}/g
  _.isFunction(transform) or (transform = (v) -> v)

  template.replace regex, (match, key) ->
    value = jetbrick.nestedValue(data, key)
    value ?= ""
    return transform(value)

###--------------------------------------------------------
 * A underscore template
 -------------------------------------------------------###
jetbrick.usTemplate = (templateString, data) ->
  settings = {
    evaluate    : /`([\s\S]+?)`/g
    interpolate : /\{([\s\S]+?)\}/g
    escape      : /@\{([\s\S]+?)\}/g
  }
  return _.template(templateString, data, settings)


