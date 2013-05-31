import groovy.transform.CompileStatic;

@CompileStatic
def static clean_files(File basedir, List<String> outputs) {
    for (def output: outputs) {
        def file = new File(basedir, output);
        if (file.exists()) {
            System.out.println "deleting ${file}";
            file.delete();
        }
    }
}

@CompileStatic
def static copy_files(File basedir, List<String> inputs, String destdir) {
    System.out.println "copying ${inputs.length} files into ${destdir}";
    
    for (def input: inputs) {
        def src = new File(basedir, input);
        def dest = new File(basedir, destdir + "/" + src.getName());

        if (!dest.exists() || dest.length() != src.length()) {
            def bytes = src.getBytes();
            dest.setBytes(bytes);
        }
    }
}

@CompileStatic
def static concat_files(File basedir, List<String> inputs, String output, boolean comments = false) {
    def input_files = [];
    for (def input: inputs) {
        input_files << new File(basedir, input);
    }
    def output_file = new File(basedir, output);

    concat_files(input_files, output_file, comments);
}

@CompileStatic
def static concat_files(List<File> inputs, File output, boolean comments = false) {
    def encoding = "utf-8";
    def contents = new StringBuffer();
    for (def input: inputs) {
        if (comments) {
            contents << """
            /***************************************
             *  ${input.name}
             **************************************/
            """.stripIndent();
        }
        contents << input.getText(encoding);
        contents << "\n";
    }
    
    output.setText(contents.toString(), encoding);
}

@CompileStatic
def static compile_js(File basedir, String input, String output) {
    compile_js(new File(basedir, input), new File(basedir, output));
}

@CompileStatic
def static compile_js(File input, File output) {
    def COFFEE = "c:\\dev\\nodejs-0.10.0\\coffee.cmd";

    def command = """
        "${COFFEE}" --compile "${input.name}"
    """.stripIndent().toString().trim();

    shell_execute(command, input.getParentFile());
}

@CompileStatic
def static compress_js(File basedir, String input, String output) {
    compress_js(new File(basedir, input), new File(basedir, output));
}

@CompileStatic
def static compress_js(File input, File output) {
    def UGLIFY_JS = "c:\\dev\\nodejs-0.10.0\\uglifyjs.cmd";

    def command = """
        "${UGLIFY_JS}" "${input}" -c -m --output "${output}"
    """.stripIndent().toString().trim();

    shell_execute(command, null);
}

@CompileStatic
def static compile_css(File basedir, String input, String output) {
    compile_css(new File(basedir, input), new File(basedir, output));
}

@CompileStatic
def static compile_css(File input, File output) {
    def command = """
        scss_compass.bat "${input}" "${output}"
    """.stripIndent().toString().trim();

    shell_execute(command, null);
}

@CompileStatic
def static compress_css(File basedir, String input, String output) {
    compress_css(new File(basedir, input), new File(basedir, output));
}

@CompileStatic
def static compress_css(File input, File output) {
    def command = """
        yui_css.bat -o "${output}" "${input}"
    """.stripIndent().toString().trim();

    shell_execute(command, null);
}

@CompileStatic
def static shell_execute(String command, File currentDir) {
    //System.out.println "shell# ${command}";
    
    def p = command.execute(new String[0], currentDir);

    def stdout;
    Thread.start { 
        stdout = p.getInputStream().getText("utf-8");
    };

    def stderr;
    Thread.start { 
        stderr = p.getErrorStream().getText("utf-8");
    };
    
    p.waitFor();

    if (p.exitValue() != 0) {
        System.err << stderr << "\n"
    }

    p.destroy();
}