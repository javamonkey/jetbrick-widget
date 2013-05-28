// Generated by CoffeeScript 1.6.1

/*--------------------------------------------------------
 * jetbrick widget
--------------------------------------------------------
*/


(function() {
  var API_DATA_KEY, API_NAME, API_SELECTOR, LoadingSprite, LockSprite, VERSION, jetbrick, loadingSprite, lockSprite, message_box, root;

  VERSION = '1.0';

  /*--------------------------------------------------------
   * jetbrick namespace
  --------------------------------------------------------
  */


  root = this;

  root.jetbrick = jetbrick = {
    version: VERSION,
    global: root
  };

  if (!String.prototype.trim) {
    String.prototype.trim = function() {
      return _.string.trim(this);
    };
  }

  String.prototype.clean = function() {
    return _.string.clean(this);
  };

  String.prototype.truncate = function(size) {
    return _.string.truncate(this, size);
  };

  String.prototype.startsWith = function(substr) {
    return _.string.startsWith(this, substr);
  };

  String.prototype.endsWith = function(substr) {
    return _.string.endsWith(this, substr);
  };

  String.prototype.blank = function() {
    return _.string.isBlank(this);
  };

  String.prototype.before = function(substr) {
    return _.string.strLeft(this, substr);
  };

  String.prototype.beforeLast = function(substr) {
    return _.string.strLeftBack(this, substr);
  };

  String.prototype.after = function(substr) {
    return _.string.strRight(this, substr);
  };

  String.prototype.afterLast = function(substr) {
    return _.string.strRightBack(this, substr);
  };

  String.prototype.capitalize = function() {
    return _.string.capitalize(this);
  };

  String.prototype.swapCase = function() {
    return _.string.swapCase(this);
  };

  String.prototype.camelize = function() {
    return _.string.camelize(this);
  };

  String.prototype.classify = function() {
    return _.string.classify(this);
  };

  String.prototype.underscored = function() {
    return _.string.underscored(this);
  };

  String.prototype.dasherize = function() {
    return _.string.dasherize(this);
  };

  String.prototype.lpad = function(length, padStr) {
    return _.string.lpad(this, length, padStr);
  };

  String.prototype.rpad = function(length, padStr) {
    return _.string.rpad(this, length, padStr);
  };

  String.repeat = function(count, separator) {
    return _.string.repeat(this, count, separator);
  };

  String.count = function(substr) {
    return _.string.count(this, substr);
  };

  String.escapeHTML = function() {
    return _.string.escapeHTML(this);
  };

  String.unescapeHTML = function() {
    return _.string.unescapeHTML(this);
  };

  String.stripTags = function(count, separator) {
    return _.string.repeat(this, count, separator);
  };

  /*---------------------------------------------------
   * "abccba".between("a") === "bccb"
   * "abccba".between("a", "c") === "b"
   * 
   * @param {String} open
   * @param {String}close
   * @returns {String}
   --------------------------------------------------
  */


  String.prototype.between = function(open, close) {
    var end, start;
    if (close == null) {
      close = open;
    }
    start = this.indexOf(open);
    if (start !== -1) {
      end = this.indexOf(close, start + open.length);
      if (end !== -1) {
        return this.substring(start + open.length, end);
      }
    }
    return null;
  };

  /*--------------------------------------------------
   * "abcdef".bytesLength() == 6
   * "\ub4a3".bytesLength() == 2
   -------------------------------------------------
  */


  String.prototype.bytesLength = function() {
    return this.replace(/[^\x00-\xff]/g, "00").length;
  };

  /*--------------------------------------------------
   * Returns a unique id of the specified length, or 32 by default
   -------------------------------------------------
  */


  jetbrick.uuid = function(length) {
    var buf, chars, i;
    if (length == null) {
      length = 32;
    }
    buf = [];
    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    i = 0;
    while (i < length) {
      buf[i] = chars.charAt(Math.floor(Math.random() * chars.length));
      i++;
    }
    return buf.join("");
  };

  /*---------------------------------------
  * @returns {string}
   --------------------------------------
  */


  Date.prototype.toJSON = function() {
    var f;
    f = function(n) {
      if (n < 10) {
        return '0' + n;
      } else {
        return n;
      }
    };
    return this.getUTCFullYear() + '-' + f(this.getUTCMonth() + 1) + '-' + f(this.getUTCDate()) + ' ' + f(this.getUTCHours()) + ':' + f(this.getUTCMinutes()) + ':' + f(this.getUTCSeconds());
  };

  /*--------------------------------------------------
   * 返回友好的时间（如:10分钟前)
   *
   * @param {String/Number/Date} date
   * @returns {String}
   -------------------------------------------------
  */


  Date.prototype.readableDate = function() {
    var ct, date, day, result;
    date = this;
    result = '';
    ct = (new Date().getTime() - date.getTime()) / 1000;
    if (ct < 60) {
      result = "刚刚";
    } else if (ct < 3600) {
      result = Math.floor(ct / 60) + "分钟前";
    } else if (ct < 86400) {
      result = Math.floor(ct / 3600) + "小时前";
    } else if (ct < 604800) {
      day = Math.floor(ct / 86400);
      result = (day < 2 ? "昨天" : day + "天前");
    } else {
      result = date.toLocaleDateString();
    }
    return result;
  };

  /*--------------------------------------------------
   * "12".pad(5) = 00012
   -------------------------------------------------
  */


  Number.prototype.pad = function(width) {
    return _.string.lpad(this.toString(), width, '0');
  };

  /*--------------------------------------------------
   * "0.1234".format() = 0.12
   * "12".format() = 12.00
   * "1234.5678".format() = 1,234.57
   * "1234.5678".format(3, false) = 1234.568
   -------------------------------------------------
  */


  Number.prototype.format = function(precision, commaDelimiters) {
    var s;
    if (precision == null) {
      precision = 2;
    }
    if (commaDelimiters == null) {
      commaDelimiters = true;
    }
    s = commaDelimiters ? ',' : '';
    return _.string.numberFormat(this, precision, '.', s);
  };

  /*--------------------------------------------------
   * Compare this between min value and max value.
   -------------------------------------------------
  */


  jetbrick.isInNumberRange = function(num, min, max) {
    return num >= min && num <= max;
  };

  /*--------------------------------------------------
   * 1234.readableSize() = '1.21KB'
   * 1234.readableSize(1) = '1.2KB'
   -------------------------------------------------
  */


  Number.prototype.readableSize = function(precision) {
    var size;
    if (precision == null) {
      precision = 2;
    }
    size = Math.floor(this);
    if (size < 1024) {
      return size.toString() + "Byte";
    }
    if (size < 1024 * 1024) {
      return (size / 1024).format(precision) + "KB";
    }
    if (size < 1024 * 1024 * 1024) {
      return (size / 1024 / 1024).format(precision) + "MB";
    }
    if (size < 1024 * 1024 * 1024 * 1024) {
      return (size / 1024 / 1024 / 1024).format(precision) + "GB";
    }
  };

  /*--------------------------------------------------
   * 1234.readableTime() = '00:00:01,234'
   * 1234.readableTime(false) = '00:00:01'
   -------------------------------------------------
  */


  Number.prototype.readableTime = function(showMills) {
    var hh, mm, ms, ss, str, time;
    if (showMills == null) {
      showMills = false;
    }
    time = this;
    hh = Math.floor(time / 3600000);
    mm = Math.floor((time - hh * 3600000) / 60000);
    ss = Math.floor((time - hh * 3600000 - mm * 60000) / 1000);
    str = hh.pad(2) + ":" + mm.pad(2) + ":" + ss.pad(2);
    if (showMills) {
      ms = Math.floor(time % 1000);
      str += "," + ms.pad(3);
    }
    return str;
  };

  /*--------------------------------------------------
   * 1234567890.readableSeconds() = '14day 6hour 56minite 8second'
   * 1234.readableSeconds(2) = '14day 6hour 56minite 7.89second'
   -------------------------------------------------
  */


  Number.prototype.readableSeconds = function(secondsPrecision) {
    var chs, dd, hh, mm, ss, time;
    if (secondsPrecision == null) {
      secondsPrecision = 0;
    }
    time = this;
    dd = Math.floor(time / 86400000);
    hh = Math.floor((time - dd * 86400000) / 3600000);
    mm = Math.floor((time - dd * 86400000 - hh * 3600000) / 60000);
    ss = (time - dd * 86400000 - hh * 3600000 - mm * 60000) / 1000.0;
    chs = [];
    if (dd > 0) {
      chs.push(dd, "天");
    }
    if (hh > 0) {
      chs.push(hh, "小时");
    }
    if (mm > 0) {
      chs.push(mm, "分");
    }
    chs.push(ss.format(secondsPrecision), "秒");
    return chs.join("");
  };

  /*----------------------------------------------------
   * isNull === null || undefined
   *
   * @param {*} obj
   * @return {Boolean}
   ---------------------------------------------------
  */


  jetbrick.isNull = function(obj) {
    return (obj === null) || (obj === void 0);
  };

  /*----------------------------------------------------
   * isNotNull === not null && not undefined
   *
   * @param {*} obj
   * @return {Boolean}
   ---------------------------------------------------
  */


  jetbrick.isNotNull = function(obj) {
    return !jetbrick.isNull(obj);
  };

  /*----------------------------------------------------
   * convert to object to string if not null
   *
   * (null / undefined) === null
   * 
   * @param {*} obj
   * @returns {String}
   ---------------------------------------------------
  */


  jetbrick.asString = function(obj) {
    if (jetbrick.isNull(obj)) {
      return null;
    }
    return obj.toString();
  };

  /*----------------------------------------------------
   * convert to object to float if not null
   *
   * (null / undefined) === null
   * ("1234.5678", 2) === 1234.56
   * 
   * @param {*} obj
   * @param {Integer} precision
   * @returns {Float}
   ---------------------------------------------------
  */


  jetbrick.asFloat = function(obj, precision) {
    var num;
    if (jetbrick.isNull(obj)) {
      return null;
    }
    if (_.isNumber(obj)) {
      return obj;
    }
    num = parseFloat(obj.toString(), 10);
    if (precision) {
      num = parseFloat(num.toFixed(precision));
    }
    return num;
  };

  /*----------------------------------------------------
   * convert to object to integer if not null.
   * If the string starts with '0x' or '-0x', parse as hex.
   *
   * (null / undefined) === null
   * ("1234") === 1234
   * ("0xFF") === 255
   * 
   * @param {*} obj
   * @returns {Integer}
   ---------------------------------------------------
  */


  jetbrick.asInt = function(obj) {
    var str;
    if (jetbrick.isNull(obj)) {
      return null;
    }
    if (_.isNumber(obj)) {
      return obj.toFixed(0);
    }
    str = obj.toString();
    return (/^\s*-?0x/i.test(str) ? parseInt(str, 16) : parseInt(str, 10));
  };

  /*----------------------------------------------------
   * Parses the object argument as a boolean.
   *
   * (null, undefined) === false
   * (true, yes, on, y, t, 1) === true
   * 
   * @param {*} obj
   * @returns {Boolean}
   ---------------------------------------------------
  */


  jetbrick.asBoolean = function(obj) {
    var s;
    if (jetbrick.isNull(obj)) {
      return false;
    }
    if (_.isBoolean(obj)) {
      return obj;
    }
    if (_.isString(obj)) {
      s = obj.toString().toLowerCase();
      return s === "true" || s === "yes" || s === "on" || s === "t" || s === "y" || s === "1";
    }
    return !!obj;
  };

  /*----------------------------------------------------
   * @required date-js
   *
   * ("2012-01-01 12:00:00") === new Date(2012-01-01 12:00:00)
   * 
   * @param {*} obj
   * @returns {Date}
   ---------------------------------------------------
  */


  jetbrick.asDate = function(obj) {
    if (jetbrick.isNull(obj)) {
      return null;
    }
    if (_.isDate(obj)) {
      return obj;
    }
    if (_.isNumber(obj)) {
      return new Date(obj);
    }
    return Date.parseExact(obj.toString(), jetbrick.asDate.DATE_FORMATER_LIST);
  };

  jetbrick.asDate.DATE_FORMATER_LIST = ["yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd", "HH:mm:ss"];

  /*----------------------------------------------------
   * ("object.func", window) === window.object.func
   * 
   * @param {*} fn
   * @param {*} context
   * @returns {Function}
   ---------------------------------------------------
  */


  jetbrick.asFunction = function(fn, context) {
    var f;
    if (jetbrick.isNull(fn)) {
      return null;
    }
    if (_.isFunction(fn)) {
      return fn;
    }
    if (context) {
      f = jetbrick.get(context, fn);
      if (_.isFunction(f)) {
        return f;
      }
    }
    f = jetbrick.get(jetbrick.global, fn);
    if (_.isFunction(f)) {
      return f;
    }
    return null;
  };

  /*----------------------------------------------------
   * ("[{id:1},{id,2}]") === [{id:1},{id,2}]
   * 
   * @required JSON2.js
   * @param {String} str
   * @returns {*}
   ---------------------------------------------------
  */


  jetbrick.asJSON = function(str) {
    if (jetbrick.isNull(str)) {
      return null;
    }
    if (_.isString(str)) {
      return JSON.parse(str);
    }
    return str;
  };

  /*---------------------------------------------------------
   * summary:
   *		Performs parameterized substitutions on a string. Throws an
   *		exception if any parameter is unmatched.
   * template:
   *		a string with expressions in the form `{key}` to be replaced.
   *      keys are case-sensitive.
   * data:
   *		hash to search for substitutions
   * transform:
   *		a function to process all parameters before substitution takes
   *		place, e.g. mylib.encodeXML
   * example:
   *		Substitutes two expressions in a string from an Array or Object
   *	|	// returns "File 'foo.html' is not found in directory '/temp'."
   *	|	// by providing substitution data in an Array
   *	|	string.substitute(
   *	|		"File '{[0]}' is not found in directory '{[1]}'.",
   *	|		["foo.html","/temp"]
   *	|	);
   *	|
   *	|	// also returns "File 'foo.html' is not found in directory '/temp'."
   *	|	// but provides substitution data in an Object structure.  Dotted
   *	|	// notation may be used to traverse the structure.
   *	|	string.substitute(
   *	|		"File '{name}' is not found in directory '{info.dir}'.",
   *	|		{ name: "foo.html", info: { dir: "/temp" } }
   *	|	);
   * example:
   *		Use a transform function to modify the values:
   *	|	// returns "file 'foo.html' is not found in directory '/temp'."
   *	|	string.substitute(
   *	|		"{data[0]} is not found in {data[1].info.dir}.",
   *	|		{ data: ["foo.html", info: { dir: "/temp" }] },
   *	|		function(str){
   *	|			// try to figure out the type
   *	|			var prefix = (str.charAt(0) == "/") ? "directory": "file";
   *	|			return prefix + " '" + str + "'";
   *	|		}
   *	|	);
   --------------------------------------------------------
  */


  jetbrick.substitute = function(template, data, transform) {
    var regex;
    regex = /\{([^{}]+)\}/g;
    _.isFunction(transform) || (transform = function(v) {
      return v;
    });
    return template.replace(regex, function(match, key) {
      var value;
      value = jetbrick.nestedValue(data, key);
      if (value == null) {
        value = "";
      }
      return transform(value);
    });
  };

  /*--------------------------------------------------------
   * A underscore template
   -------------------------------------------------------
  */


  jetbrick.usTemplate = function(templateString, data) {
    var settings;
    settings = {
      evaluate: /`([\s\S]+?)`/g,
      interpolate: /\{([\s\S]+?)\}/g,
      escape: /@\{([\s\S]+?)\}/g
    };
    return _.template(templateString, data, settings);
  };

  /*--------------------------------------------------
   * Checks whether the String is all number [0-9]+.
   -------------------------------------------------
  */


  String.prototype.isNumeric = function() {
    return /^[0-9]+$/.test(this);
  };

  /*--------------------------------------------------
   * Checks whether the String is all alpha [a-zA-Z]+.
   -------------------------------------------------
  */


  String.prototype.isAlpha = function() {
    return /^[a-zA-Z]+$/.test(this);
  };

  /*--------------------------------------------------
   * Checks whether the String is all number [a-zA-Z0-9]+.
   -------------------------------------------------
  */


  String.prototype.isAlphaNumeric = function() {
    return /^[a-zA-Z0-9]+$/.test(this);
  };

  /*--------------------------------------------------
   * Checks whether the String is IP address.
   -------------------------------------------------
  */


  String.prototype.isIPAddress = function() {
    var arr, i, ip, re, ret;
    ip = this;
    re = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;
    ret = re.test(ip);
    if (!ret) {
      return false;
    }
    arr = ip.split(".");
    i = 0;
    while (i < 4) {
      arr[i] = parseInt(arr[i], 10);
      if (arr[i] > 255) {
        return false;
      }
      i++;
    }
    return true;
  };

  /*--------------------------------------------------
   * Checks whether the String is EMAIL address.
   -------------------------------------------------
  */


  String.prototype.isEmail = function() {
    return /^[A-Z0-9._-]+@[A-Z0-9.-]+.[A-Z]{2,4}$/i.test(this);
  };

  /*--------------------------------------------------
   * Checks whether the String a valid Java Integer number.
   -------------------------------------------------
  */


  String.prototype.isInteger = function(radix) {
    var n, s;
    if (radix == null) {
      radix = 10;
    }
    s = this;
    n = parseInt(s, radix);
    return !isNaN(n) && n.toString() === s;
  };

  /*--------------------------------------------------
   * Checks whether the String a valid Java Float number.
   -------------------------------------------------
  */


  String.prototype.isFloat = function() {
    var f, s, str;
    s = str = this;
    f = parseFloat(s);
    if (!isNaN(f)) {
      str = f.toString();
      if (str.indexOf(".") > -1) {
        str = str.rpad(s.length, "0");
      } else if (s.length > str.length) {
        str = str + ".0";
        str = str.rpad(s.length, "0");
      }
      return str.toString() === s.toString();
    } else {
      return false;
    }
  };

  /*-----------------------------------------------------
   * 生成 namespace, 如果存在，则直接返回.
   * jetbrick.namespace("jetbrick.string") === window.jetbrick.string
   * jetbrick.namespace("jetbrick.string", root) === root.jetbrick.string
   *
   * @param {String} ns
   * @param {Object} context
   * @returns {Object}
  ----------------------------------------------------
  */


  jetbrick.namespace = function(ns, context) {
    var ctx, name, _i, _len, _ref;
    if (context == null) {
      context = jetbrick.global || window;
    }
    _ref = ns.split('.');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      name = _ref[_i];
      ctx = context[name];
      if (typeof ctx === 'undefined') {
        ctx = context[name] = {};
      }
      context = ctx;
    }
    return context;
  };

  /*-----------------------------------------------------
   * var xmlhttp = jetbrick.tryThese(
   *   function() {return new ActiveXObject("Msxml2.XMLHTTP");},
   *   function() {return new ActiveXObject("Microsoft.XMLHTTP");},
   *   function() {return new XMLHttpRequest();}
   * );
  ----------------------------------------------------
  */


  jetbrick.tryThese = function() {
    var fn, _i, _len;
    for (_i = 0, _len = arguments.length; _i < _len; _i++) {
      fn = arguments[_i];
      try {
        return fn();
      } catch (e) {

      }
    }
    return false;
  };

  /*-----------------------------------------------
   * Return the value of the (possibly nested) property of the
   * specified name, for the specified object.
   *
   * jetbrick.nestedValue(obj, 'users[0].name');
   ----------------------------------------------
  */


  jetbrick.nestedValue = function(obj, keys) {
    var index, key;
    if (jetbrick.isNull(obj)) {
      return null;
    }
    if (jetbrick.isNull(keys)) {
      return null;
    }
    if (keys.indexOf(".") > 0) {
      key = keys.before(".");
      obj = jetbrick.nestedValue(obj, key);
      keys = keys.after(".");
      return jetbrick.nestedValue(obj, keys);
    } else if (keys.indexOf("[") > 0) {
      key = keys.before("[");
      index = keys.between("[", "]");
      obj = obj[key];
      index = jetbrick.asInt(index);
      return obj[index];
    } else {
      return obj[keys];
    }
  };

  /*--------------------------------------------------------
   * jetbrick api namespace
  --------------------------------------------------------
  */


  jetbrick.api = {};

  /*--------------------------------------------------------
   * 自动初始化所有绑定的 api 组件
   * 并返回第一个 dom 对应的 apiName 的 Component object
   * 
   * Usage:
   *   <tag api="widget-1,widget-2" ... />
   *   obj1 = $('tag').apiComponents()
   *   obj2 = $('tag').apiComponents('widget-2')
   *
   * @param {String} apiName 要返回的 apiName
   * @return {Object} return object instance
   -------------------------------------------------------
  */


  API_NAME = "api";

  API_SELECTOR = "[" + API_NAME + "]";

  API_DATA_KEY = "DEFAULT-API-KEY";

  $.fn.apiComponents = function(apiName) {
    this.each(function() {
      var apiClass, apiNames, dom, obj, _i, _len, _ref;
      dom = $(this);
      apiNames = dom.attr(API_NAME);
      if (apiNames) {
        _ref = apiNames.split(',');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          apiName = _ref[_i];
          apiName = $.trim(apiName).camelize().capitalize();
          apiClass = jetbrick.api[apiName];
          if (!apiClass) {
            throw new Error("component is not available: " + apiName);
          }
          if (!$.isFunction(apiClass)) {
            throw new Error("jetbrick.api." + apiName + " is not a Javascript Class");
          }
          if (!dom.data(apiName)) {
            obj = new apiClass(dom);
            dom.data(apiName, obj);
            if (!dom.data(API_DATA_KEY)) {
              dom.data(API_DATA_KEY, obj);
            }
          }
        }
      } else {
        return dom.find(API_SELECTOR).apiComponents();
      }
    });
    if (apiName == null) {
      apiName = API_DATA_KEY;
    }
    return this.data(apiName);
  };

  $(function() {
    return $(API_SELECTOR).apiComponents();
  });

  jetbrick.webroot = function() {
    var path;
    if (jetbrick.webroot.cache) {
      return jetbrick.webroot.cache;
    }
    path = ".";
    $("script[src*=jetbrick]").each(function() {
      var s;
      s = this.src;
      if (s.endsWith(".js")) {
        path = s.beforeLast(s, "/");
        return false;
      }
    });
    if (path.endsWith("/js")) {
      path = path.beforeLast("/js");
    }
    if (path.endsWith("/share")) {
      path = path.beforeLast(path, "/share");
    }
    if (path.endsWith("/static")) {
      path = path.beforeLast(path, "/static");
    }
    return jetbrick.webroot.cache = path;
  };

  /*--------------------------------------------------------
   * @param {String} effect              default/fade/slide
   * @param {String} toggle              show/hide/toggle
   * @param {String/Number} duration     default is 400
   * @param {Function} complete          callback function when completed
   * @see jQuery Effects: http://api.jquery.com/category/effects/
   -------------------------------------------------------
  */


  $.fn.effectiveToggle = function(effect, toggle, duration, complete) {
    var fn;
    if (effect == null) {
      effect = "default";
    }
    if (effect === "default") {
      fn = toggle;
    } else if (effect === "fade") {
      if (toggle === "show") {
        fn = "fadeIn";
      }
      if (toggle === "hide") {
        fn = "fadeOut";
      }
      if (toggle === "toggle") {
        fn = "fadeToggle";
      }
    } else if (effect === "slide") {
      if (toggle === "show") {
        fn = "slideDown";
      }
      if (toggle === "hide") {
        fn = "slideUp";
      }
      if (toggle === "toggle") {
        fn = "slideToggle";
      }
    }
    return $.fn[fn].call(this, duration, complete);
  };

  /*--------------------------------------------------------
   * jQuery.fn.outerHTML
   -------------------------------------------------------
  */


  $.fn.outerHTML = function() {
    var attribute, dom, html, name, tagName, value, _i, _len, _ref;
    if (this.length === 0) {
      return "";
    }
    dom = this[0];
    html = dom.outerHTML;
    if (html) {
      return html;
    }
    tagName = dom.tagName.toLowerCase();
    html = "<" + tagName;
    _ref = dom.attributes;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      attribute = _ref[_i];
      name = attribute.nodeName;
      value = attribute.nodeValue;
      if (value) {
        value = value.replace("'", "\\'");
      }
      html += " " + name + "='" + value + "'";
    }
    return html += ">" + (this.html()) + "</" + tagName + ">";
  };

  /*--------------------------------------------------------
   * 获取整个document最大可用的 zIndex
   *
   * @returns {Number}
   -------------------------------------------------------
  */


  jetbrick.zIndex = function() {
    var max, node, nodes, zIndex, _i, _len;
    nodes = document.getElementsByTagName("*");
    max = 0;
    for (_i = 0, _len = nodes.length; _i < _len; _i++) {
      node = nodes[_i];
      zIndex = (+node.style.zIndex) || 0;
      if (max < zIndex) {
        max = zIndex;
      }
    }
    return max + 1;
  };

  /*--------------------------------------------------------
   * 添加 name=value 到 URL 的 QueryString 中.
   * ("index.html", "id", 1) === "index.html?id=1"
   * ("index.html?id=1", "name", "jack") === "index.html?id=1&name=jack"
   *
   * @param {String} url
   * @param {String} name
   * @param {*} value
   * @returns {String}
   -------------------------------------------------------
  */


  jetbrick.addQueryString = function(url, name, value) {
    url += url.indexOf("?") < 0 ? "?" : "&";
    url += name + "=" + jetbrick.asString(value);
    return url;
  };

  /*--------------------------------------------------------
   * @param {String} url
   * @param {String} target     default is "_self"
   -------------------------------------------------------
  */


  jetbrick.redirectUrl = function(url, target) {
    url = jetbrick.addQueryString(url, "_", Math.random());
    return window.open(url, target || "_self", null, true);
  };

  /*-------------------------------------------------------------
   * 实现INPUT只能输入数字和小数点
   *
   * Usage:
   *   <input api="numeric-input" data-decimal="false" />
  -------------------------------------------------------------
  */


  jetbrick.api.NumericInput = (function() {

    function NumericInput(dom, options) {
      this.dom = dom;
      this.options = $.extend({}, this.dom.data(), options);
      this.dom.css("ime-mode", "disabled");
      this.dom.on("keypress", function(e) {
        var code;
        code = e.which;
        return code >= 48 && code <= 57 || code === 46;
      });
      this.dom.on("blur", function() {
        if (this.value.lastIndexOf(".") === (this.value.length - 1)) {
          return this.value = this.value.substr(0, this.value.length - 1);
        } else {
          if (isNaN(this.value)) {
            return this.value = "";
          }
        }
      });
      this.dom.on("paste", function() {
        var s;
        s = clipboardData.getData("text");
        if (/\D/.test(s)) {
          this.value = s.replace(/^0*/, "");
        }
        return false;
      });
      this.dom.on("dragenter", function() {
        return false;
      });
      this.dom.on("drop", function() {
        return false;
      });
      this.dom.on("keyup", function(e) {
        var s, _ref;
        if ((35 <= (_ref = e.which) && _ref <= 40)) {
          return true;
        }
        s = this.value;
        s = s.replace(/[^\d.]/g, "");
        s = s.replace(/^\./g, "");
        s = s.replace(/\.{2,}/g, ".");
        s = s.replace(".", "$#$").replace(/\./g, "").replace("$#$", ".");
        return this.value = s;
      });
    }

    return NumericInput;

  })();

  LockSprite = (function() {

    function LockSprite() {
      this.dialogs = [];
      this.mask = $('<div class="js-lock" />').css({
        'display': 'none',
        'position': 'fixed',
        'width': '100%',
        'height': '100%',
        'left': 0,
        'top': 0,
        'background-color': '#000'
      });
      $(document.body).append(this.mask);
    }

    LockSprite.prototype.lock = function(zIndex, opacity, duration, callback) {
      this.mask.css({
        'opacity': opacity || 0.4,
        'z-index': zIndex
      });
      if (duration) {
        return this.mask.fadeIn(duration, callback);
      } else {
        return this.mask.show();
      }
    };

    LockSprite.prototype.unlock = function() {
      return this.mask.hide();
    };

    LockSprite.prototype.push = function(dialog) {
      this.dialogs.push({
        name: dialog,
        zIndex: jetbrick.zIndex()
      });
      return this.lock(item.zIndex);
    };

    LockSprite.prototype.pop = function(dialog) {
      this.dialogs = _.reject(this.dialogs, function(item) {
        return item.name === dialog;
      });
      if (this.dialogs.length === 0) {
        return this.unlock();
      } else {
        return this.lock(this.dialogs[this.dialogs.length - 1].zIndex);
      }
    };

    return LockSprite;

  })();

  lockSprite = new LockSprite();

  LoadingSprite = (function() {

    function LoadingSprite() {
      var html, image;
      image = jetbrick.webroot() + '/static/images/widget/ajax-loading.gif';
      html = "<div class=\"js-ajax-loading\">\n  <img src=\"" + image + "\" style=\"vertical-align:middle\" />\n  <span style=\"padding:0 12px\">正在请求服务器，请稍后 ...</span>\n  <a href=\"javascript:;\">(X)</a>\n</div>";
      this.loading = $(html).css({
        'position': 'fixed',
        'dispaly': 'block',
        'width': 'auto',
        'left': '50%',
        'top': '38%',
        'font-size': '14px',
        'border': '6px solid #555',
        'background-color': '#fff',
        'padding': '15px 20px',
        '-webkit-border-radius': '5px',
        '-moz-border-radius': '5px',
        'border-radius': '5px',
        '-webkit-box-shadow': '0 1px 10px rgba(0, 0, 0, 0.4)',
        '-moz-box-shadow': '0 1px 10px rgba(0, 0, 0, 0.4)',
        'box-shadow': '0 1px 10px rgba(0, 0, 0, 0.4)'
      });
      $(document.body).append(this.loading);
      this.loading.find('a').on('click', $.proxy(this.hide, this));
    }

    LoadingSprite.prototype.show = function() {
      lockSprite.push('loadingSprite');
      this.loading.css({
        'margin-left': 0 - this.$loading.outerWidth() / 2,
        'margin-top': 0 - this.$loading.outerHeight() / 2,
        'z-index': jetbrick.zIndex()
      });
      return this.loading.show();
    };

    LoadingSprite.prototype.hide = function(unlock) {
      this.loading.hide();
      if (unlock) {
        return lockSprite.pop('loadingSprite');
      }
    };

    return LoadingSprite;

  })();

  loadingSprite = new LoadingSprite();

  jetbrick.ajax = function(url, params, callback, method, dataType) {
    loadingSprite.show();
    return $.ajax({
      global: false,
      cache: false,
      async: true,
      type: method || 'GET',
      url: url,
      data: params,
      dataType: dataType || 'json',
      success: function() {
        loadingSprite.hide(false);
        if (callback) {
          callback.apply(this, arguments);
        }
        return loadingSprite.hide(true);
      },
      error: function() {
        loadingSprite.hide(false);
        jetbrick.error('服务请求失败，请联系管理员或者稍后重试。');
        return loadingSprite.hide(true);
      }
    });
  };

  jetbrick.dialog = function(title, content, callback) {
    var id;
    id = _.uniqueId('dialog_');
    lockSprite.push(id);
    return art.dialog({
      id: id,
      fixed: true,
      lock: false,
      title: title,
      content: content,
      zIndex: jetbrick.zIndex(),
      initialize: callback != null ? callback.initialize : void 0,
      ok: callback != null ? callback.ok : void 0,
      cancel: callback != null ? callback.cancel : void 0,
      beforeunload: function() {
        var _ref;
        if (callback != null) {
          if ((_ref = callback.beforeunload) != null) {
            _ref.apply(this, arguments);
          }
        }
        return lockSprite.pop(name);
      }
    });
  };

  message_box = function(icon, title, content, yes_fn, no_fn) {
    content = "<span class=\"js-dialog-icon js-dialog-icon-" + icon + "\"></span>\n<span>" + content + "</span>";
    if ($.isFunction(yes_fn)) {
      yes_fn = function() {
        return yes_fn.apply(this, arguments);
      };
    }
    if ($.isFunction(no_fn)) {
      no_fn = function() {
        return no_fn.apply(this, arguments);
      };
    }
    return jetbrick.dialog(title, content, {
      ok: yes_fn,
      cancel: no_fn
    });
  };

  jetbrick.info = function(content, callback) {
    return message_box('info', '消息', content, callback || true);
  };

  jetbrick.warning = function(content, callback) {
    return message_box('warning', '警告', content, callback || true);
  };

  jetbrick.error = function(content, callback) {
    return message_box('error', '错误', content, callback || true);
  };

  jetbrick.confirm = function(content, yes_fn, no_fn) {
    return message_box('question', '确认', content, yes_fn || true, no_fn || true);
  };

  jetbrick.alert = function(succ, content, callback) {
    if (succ) {
      return jetbrick.info(content, callback);
    } else {
      return jetbrick.error(content, callback);
    }
  };

  jetbrick.prompt = function(content, yes_fn, value) {
    if (value == null) {
      value = "";
    }
    content = $("<div style=\"margin-bottom:5px;font-size:12px;\">" + content + "</div>\n<div><input value=\"" + value + "\" style=\"width:18em;padding:6px 4px;\"></div>");
    return message_box('question', '提问', content, function() {
      var input;
      input = content.find('input');
      return yes_fn != null ? yes_fn.call(this, input.val()) : void 0;
    });
  };

}).call(this);
