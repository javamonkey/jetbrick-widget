@echo off

set JAVA_HOME=C:\dev\jdk1.7.0_15
set JAVA_OPTS=-Xms256m -Xmx512m
set PATH=%JAVA_HOME%\bin;%PATH%

set YUI_PATH=%~dp0
if "%YUI_PATH:~-1%"=="\" SET YUI_PATH=%YUI_PATH:~0,-1%

set YUI_JAR=%YUI_PATH%\yuicompressor-2.4.7.jar

set YUI_CSS_OPTS=--type css --charset utf-8


java -jar "%YUI_JAR%" %YUI_CSS_OPTS% %*

