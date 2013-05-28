
def basedir = new File("..").getCanonicalFile();

def inputs = [
    "core/version.coffee",
    "core/string.coffee",
    "core/date.coffee",
    "core/number.coffee",
    "core/type.coffee",
    "core/template.coffee",
    "core/validate.coffee",
    "core/utils.coffee",

    "widget/api/api-loader.coffee",
    "widget/api/api-utils.coffee",
    "widget/numeric-input/numeric-input.coffee",
    //"widget/auto-switcher/auto-switcher.coffee",
    "widget/dialog/dialog.coffee",
];

def outputs = [
    "build/js/jetbrick-widget.coffee", 
    "build/js/jetbrick-widget.js", 
    "build/js/jetbrick-widget.min.js"
];


//////////////////////////////////////////////////////////////////////

BuildUtils.clean_files(basedir, outputs);

println "concat: ${outputs[0]}";
BuildUtils.concat_files(basedir, inputs, outputs[0], false);

println "compile: ${outputs[1]}";
BuildUtils.compile_js(basedir, outputs[0], outputs[1]);

println "compress: ${outputs[2]}";
BuildUtils.compress_js(basedir, outputs[1], outputs[2]);

println "";

