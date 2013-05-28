
def basedir = new File("..").getCanonicalFile();

clean_directory(new File(basedir, "core"));
clean_directory(new File(basedir, "scss"));
clean_directory(new File(basedir, "widget"));

def clean_directory(File dir) { 
    for (File file: dir.listFiles()) {
        if (file.isDirectory()) {
            clean_directory(file); 
        } else {
            if (file.getName().endsWith(".js") || file.getName().endsWith(".css")) {
                println "deleting: ${file}";
                file.delete();
            }
        }
    } 
}

