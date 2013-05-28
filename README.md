# [Jetbrick Widget v0.1](http://subchen.github.io/jetbrick-widget/)

Jetbrick-widget is a data-driven and powerful front-end framework for faster and easier web development, created and maintained by [Sub Chen](mailto:subchen@gmail.com).

To get started, checkout http://subchen.github.io/jetbrick-widget/

## Overview

Including following components in current version.

* form-validator
* dropdown
* scroll-to-top
* date-picker
* time-picker
* flash-uploader
* iphone-toggle
* dialog, info, wanring, error ...

## Usage

### Via api & data attributes

Add `api="date-picker"` into an input to create a date picker.

```html
<input type="text" name="date"
       api="date-picker" 
       data-min="2013-01-01" />
```

### Via JavaScript

A programmatic api to create a date picker.

```html
<input type="text" name="date" />

var dataPicker = $('input[name=date]').apiComponents();
```

## Dependencies

* [jQuery 1.9.1](http://jquery.com/)
* [Twitter Bootstrap 2.3.1](http://twitter.github.io/bootstrap/)
* [Underscore.js 1.4.4](http://underscorejs.org/)
* [Underscore.string.js 2.3.0](http://epeli.github.io/underscore.string/)
* [Font Awesome 3.1.1](http://fortawesome.github.io/Font-Awesome/)
* [zTree 3.5.12](http://www.ztree.me/)
* [xhEditor 1.2.1](http://xheditor.com/)
* [Select2 3.3.2](http://ivaynberg.github.io/select2/)
* [artDialog 5.0.4](http://aui.github.io/artDialog/)
* [pjax 1.6.1](https://github.com/defunkt/jquery-pjax)
* [JSON-js](https://github.com/douglascrockford/JSON-js)

## How to build

Please install following tools first.

* [JDK 1.6.x]
* [Groovy 2.x]
* [Ruby 1.9.x], [Sass/Scss], [Compass]
* [Node.js 0.10.x], [CoffeeScript], [uglifyjs]

```shell
git clone https://github.com/subchen/jetbrick-widget.git
cd jetbrick-widget

```

Open *.bat and BuildUtils.groovy, then set the correct path for build tools.

```shell
cd build
build.bat
```

## Bug tracker

Have a bug or a feature request? [Please open a new issue](https://github.com/subchen/jetbrick-widget/issues). Before opening any issue, please search for existing issues and read the Issue Guidelines.

## Authors

**Sub Chen**

* [subchen@gmail.com](mailto:subchen@gmail.com)
* http://github.com/subchen


## Copyright and license

Copyright 2013-2020 [subchen@gmail.com](mailto:subchen@gmail.com)

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this work except in compliance with the License. You may obtain a copy of the License in the LICENSE file, or at:

http://www.apache.org/licenses/LICENSE-2.0
