@echo off

set JAVA_HOME=C:\dev\jdk1.7.0_15
set JAVA_OPTS=-Xms256m -Xmx512m
set PATH=%JAVA_HOME%\bin;%PATH%

set GROOVY_HOME=C:\dev\groovy-2.1.1
set PATH=%GROOVY_HOME%\bin;%PATH%

set PWD=%cd%

cd /d %~dp0 & call groovy clean.groovy & cd /d %PWD%


