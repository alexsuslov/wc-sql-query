'use strict';
var ObjectId, Query, Schema, mongoose;

mongoose = require('mongoose');

Schema = mongoose.Schema;

ObjectId = Schema.Types.ObjectId;


/*
Express req.query -> mysql select where, order, limit
@author Alex Suslov <suslov@me.com>
@copyright MIT
 */

Query = {
  query: false,

  /*
  main
  @param query[String] string from EXPRESS req
  @return Object
    conditions: mongo filter object
    options: mongo find options
   */
  main: function(query) {
    this.query = query;
    this.where = '';
    this.order = '';
    this.sort().lim().opt();
    return this;
  },

  /*
  @param value[String] 'name=test'
  @return Object {name:'test'}
   */
  expression: function(value) {
    var data, ret;
    data = value.split('=');
    ret = {};
    ret[data[0]] = this.parse(data[1]);
    return ret;
  },
  logical: function(name) {
    var Arr, value;
    if (this.query[name]) {
      Arr = this.query[name].split(',');
      if (Arr.length) {
        this.conditions['$' + name] = (function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = Arr.length; _i < _len; _i++) {
            value = Arr[_i];
            _results.push(this.expression(value));
          }
          return _results;
        }).call(this);
      }
      delete this.query[name];
    }
    return this;
  },
  parseVal: function(val) {
    if (this.type === 'Number') {
      return parseFloat(val);
    }
    if (this.type === 'Boolean') {
      return !!val;
    }
    if (this.type === 'ObjectID') {
      return new ObjectId(val);
    }
    if (this.type === 'Date') {
      return new Date(val);
    }
    return val;
  },

  /*
  Clean regexp simbols
  @param str[String] string to clean
  @return [String] cleaning string
   */
  escapeRegExp: function(str) {
    return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
  },

  /*
  Parse ~, !, ....
  @param str[String]  '!name'
  @return Object condition value
   */
  parse: function(str) {
    var eqv, tr;
    tr = this._str(str);
    eqv = function(simbol, val) {
      return simbol + '\'' + val + '\'';
    };
    switch (str[0]) {
      case '>':
        return eqv('>', this.parseVal(tr));
      case ']':
        return eqv('=>', this.parseVal(tr));
      case '<':
        return eqv('<', this.parseVal(tr));
      case '[':
        return eqv('<=', this.parseVal(tr));
      case '!':
        return eqv('!=', this.parseVal(tr));
      default:
        return eqv('=', this.parseVal(str));
    }
  },

  /*
  Cut first char from string
  @param str[String]  '!test'
  @return String 'test'
   */
  _str: function(str) {
    return str.substr(1, str.length);
  },

  /*
  Create options from query
   */
  opt: function() {
    var comma, name, val;
    if (this.query) {
      comma = '';
      for (name in this.query) {
        this.query[name] = decodeURI(this.query[name]);
        if (this.query[name]) {
          val = this.parse(this.query[name]);
          this.where += "" + comma + name + val;
          comma = ', ';
        }
      }
      console.log(this.where);
    }
    return this;
  },
  detectType: function(name) {
    var _ref;
    if (this.model && this.model.schema.path(name)) {
      if (this.model.schema.path(name).instance === 'undefined') {
        if ((_ref = model.schema.path(name).options) != null ? _ref.type : void 0) {
          if (model.schema.path(name).options.type.name === Date) {
            return 'Date';
          }
          if (model.schema.path(name).options.type.name === Boolean) {
            return 'Boolean';
          }
          if (model.schema.path(name).options.type.name === Array) {
            return 'Array';
          }
        }
      }
      if (this.model) {
        return this.model.schema.path(name).instance;
      }
    }
    return 'String';
  },

  /*
  Create sort from query
   */
  sort: function() {
    if (this.query.order) {
      if (this.query.order[0] === '-') {
        this.order = "" + (this._str(this.query.order)) + " DESC";
      } else {
        this.order = "" + this.query.order;
      }
      delete this.query.order;
    }
    return this;
  },

  /*
  Create limit from query
   */
  lim: function() {
    var limit, skip;
    skip = parseInt(this.query.skip || 0);
    delete this.query.skip;
    limit = parseInt(this.query.limit || 25);
    delete this.query.limit;
    this.limit = "" + skip + ", " + limit;
    return this;
  }
};

module.exports = function(query) {
  return Query.main(query);
};

module.exports.Query = Query;
