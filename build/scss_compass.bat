@echo off

set RUBY_HOME=C:\dev\ruby-1.9.3
set PATH=%RUBY_HOME%\bin;%PATH%

set COMPASS_LIB=%RUBY_HOME%\lib\ruby\gems\1.9.1\gems\compass-0.12.2\frameworks\compass\stylesheets
set SCSS_OPTS=-E utf-8 --compass --load-path "%COMPASS_SCSS_LIB%" --style expanded --no-cache

scss %SCSS_OPTS% %*
