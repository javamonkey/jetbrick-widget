
def basedir = new File("..").getCanonicalFile();

def fonts = [
    "vendor/font-awesome/font/FontAwesome.otf",
    "vendor/font-awesome/font/fontawesome-webfont.eot",
    "vendor/font-awesome/font/fontawesome-webfont.svg",
    "vendor/font-awesome/font/fontawesome-webfont.ttf",
    "vendor/font-awesome/font/fontawesome-webfont.woff",
];

def images = [
    "widget/dialog/assets/succeed.png",
    "widget/dialog/assets/warning.png",
    "widget/dialog/assets/error.png",
    "widget/dialog/assets/question.png",
];

def swfs = [
    "widget/flash-uploader/FlashUploader.swf",
];

//////////////////////////////////////////////////////////////////////

println "copying resources ...";
BuildUtils.copy_files(basedir, fonts, "build/font");
BuildUtils.copy_files(basedir, images, "build/images");
BuildUtils.copy_files(basedir, swfs, "build/swf");

println "";

