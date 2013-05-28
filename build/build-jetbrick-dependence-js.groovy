
def basedir = new File("..").getCanonicalFile();

def inputs = [
    "vendor/jquery/jquery-1.9.1.js",
    "vendor/jquery/jquery-migrate-1.2.1.js",
//    "vendor/bootstrap/js/bootstrap.js"
    "vendor/underscore/underscore.js",
    "vendor/underscore/underscore.string.js",
    "vendor/date-js/date.js",
    "vendor/json/json2.js",
    "vendor/handlebars/handlebars.js",
    "vendor/pjax/jquery.pjax.js",
    "vendor/art-dialog/artDialog.js",
    "vendor/select2/select2.js",
    "vendor/select2/select2_locale_zh-CN.js",
    "vendor/ztree/js/jquery.ztree.all-3.5.js",
    "vendor/xheditor/xheditor-1.2.1.min.js",
    "vendor/xheditor/xheditor_lang/zh-cn.js",
    
    "vendor/SyntaxHighlighter/scripts/shCore.min.js",   // missing ";" in file end
    //"vendor/SyntaxHighlighter/scripts/shBrushAppleScript.js",
    "vendor/SyntaxHighlighter/scripts/shBrushAS3.js",
    "vendor/SyntaxHighlighter/scripts/shBrushBash.js",
    //"vendor/SyntaxHighlighter/scripts/shBrushColdFusion.js",
    "vendor/SyntaxHighlighter/scripts/shBrushCpp.js",
    "vendor/SyntaxHighlighter/scripts/shBrushCSharp.js",
    "vendor/SyntaxHighlighter/scripts/shBrushCss.js",
    "vendor/SyntaxHighlighter/scripts/shBrushDelphi.js",
    "vendor/SyntaxHighlighter/scripts/shBrushDiff.js",
    //"vendor/SyntaxHighlighter/scripts/shBrushErlang.js",
    "vendor/SyntaxHighlighter/scripts/shBrushGroovy.js",
    "vendor/SyntaxHighlighter/scripts/shBrushJava.js",
    "vendor/SyntaxHighlighter/scripts/shBrushJavaFX.js",
    "vendor/SyntaxHighlighter/scripts/shBrushJScript.js",
    "vendor/SyntaxHighlighter/scripts/shBrushPerl.js",
    "vendor/SyntaxHighlighter/scripts/shBrushPhp.js",
    "vendor/SyntaxHighlighter/scripts/shBrushPlain.js",
    "vendor/SyntaxHighlighter/scripts/shBrushPowerShell.js",
    "vendor/SyntaxHighlighter/scripts/shBrushPython.js",
    "vendor/SyntaxHighlighter/scripts/shBrushRuby.js",
    "vendor/SyntaxHighlighter/scripts/shBrushSass.js",
    "vendor/SyntaxHighlighter/scripts/shBrushScala.js",
    "vendor/SyntaxHighlighter/scripts/shBrushSql.js",
    "vendor/SyntaxHighlighter/scripts/shBrushVb.js",
    "vendor/SyntaxHighlighter/scripts/shBrushXml.js",
];

def outputs = [
    "build/js/jetbrick-dependence.js", 
    "build/js/jetbrick-dependence.min.js"
];

//////////////////////////////////////////////////////////////////////

def uncompress_files = [];
def compress_files = [];

for (def input: inputs) {
    def compress_input = input.replaceFirst("(\\.min)?\\.js", ".min.js")

    def uncompress_file = new File(basedir, input);
    def compress_file = new File(basedir, compress_input);

    if (!compress_file.exists()) {
        println "compress: ${compress_file}";
        BuildUtils.compress_js(uncompress_file, compress_file);
    }

    uncompress_files << uncompress_file;
    compress_files << compress_file;
}

BuildUtils.clean_files(basedir, outputs);

println "concat: ${outputs[0]}";
BuildUtils.concat_files(uncompress_files, new File(basedir, outputs[0]), true);

println "compress: ${outputs[1]}";
BuildUtils.concat_files(compress_files, new File(basedir, outputs[1]));

println "";



