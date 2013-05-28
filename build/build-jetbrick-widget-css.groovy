
def basedir = new File("..").getCanonicalFile();

def inputs = [
    "scss/jetbrick-widget.scss"
];

def outputs = [
    "build/css/jetbrick-widget.css",
    "build/css/jetbrick-widget.min.css"
];


//////////////////////////////////////////////////////////////////////

BuildUtils.clean_files(basedir, outputs);

println "compile: ${outputs[0]}";
BuildUtils.compile_css(basedir, inputs[0], outputs[0]);

println "compress: ${outputs[1]}";
BuildUtils.compress_css(basedir, outputs[0], outputs[1]);

println "";

