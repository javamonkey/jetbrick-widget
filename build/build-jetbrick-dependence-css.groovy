
def basedir = new File("..").getCanonicalFile();

def inputs = [
    "vendor/SyntaxHighlighter/styles/shCore.css",
    "vendor/SyntaxHighlighter/styles/shThemeEclipse.css",
    "vendor/font-awesome/css/font-awesome.css",
];

def outputs = [
    "build/css/jetbrick-dependence.css", 
    "build/css/jetbrick-dependence.min.css"
];


//////////////////////////////////////////////////////////////////////

BuildUtils.clean_files(basedir, outputs);

println "concat: ${outputs[0]}";
BuildUtils.concat_files(basedir, inputs, outputs[0], true);

println "compress: ${outputs[1]}";
BuildUtils.compress_css(basedir, outputs[0], outputs[1]);

println "";

