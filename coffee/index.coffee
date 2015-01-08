'use strict'
mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
###
Express req.query -> mysql select where, order, limit
@author Alex Suslov <suslov@me.com>
@copyright MIT
###
Query =
  query:false

  ###
  main
  @param query[String] string from EXPRESS req
  @return Object
    conditions: mongo filter object
    options: mongo find options
  ###
  main:(@query)->
    @where = ''
    @order = ''

    # @todo: логические операции
    # for name in ['or','and']
    #   @logical(name)
    @sort().lim().opt()
    # @order().limit().opt()
    @

  ###
  @param value[String] 'name=test'
  @return Object {name:'test'}
  ###
  expression:(value)->
    data = value.split '='
    ret = {}
    ret[data[0]] = @parse data[1]
    ret

  #create logical function
  # @param name[String] function name ['or','and']
  # @return Object
  logical:(name)->
    if @query[name]
      Arr = @query[name].split ','
      if Arr.length
        @conditions['$' + name] = (for value in Arr
          @expression value)
      delete @query[name]
    @

  parseVal:(val)->
    return parseFloat val   if @type is 'Number'
    return !!val            if @type is 'Boolean'
    return new ObjectId val if @type is 'ObjectID'
    return new Date val     if @type is 'Date'
    val


  ###
  Clean regexp simbols
  @param str[String] string to clean
  @return [String] cleaning string
  ###
  escapeRegExp: (str)->
    str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&")

  ###
  Parse ~, !, ....
  @param str[String]  '!name'
  @return Object condition value
  ###
  parse:(str)->
    tr = @_str str
    eqv = (simbol, val)->
      simbol + '\'' + val + '\''
    switch str[0]
      # when '%'
      #   return $mod: tr.split '|' if str[0] is '%'
      # # in
      # return $in: tr.split '|' if str[0] is '@'
      # # nin
      # return $nin: tr.split '|' if str[0] is '#'
      # gt
      when '>'
        eqv '>', @parseVal(tr)
      # gte
      when ']'
        eqv '=>', @parseVal(tr)
      # lt
      when '<'
        eqv '<', @parseVal(tr)
      # lte
      # return $lte: @parseVal tr if str[0] is
      when '['
        eqv '<=', @parseVal(tr)
      # not eq
      when '!'
        eqv '!=', @parseVal(tr)
      # Exists
      # return "$exists": true if str is '+'
      # return "$exists": false if str is '-'
      # # ~regex
      # return $regex:@escapeRegExp( tr), $options:'i' if str[0] is '~'
      # text
      # return $text:$search:tr if str[0] is '$'
      else
        eqv '=', @parseVal(str)



  ###
  Cut first char from string
  @param str[String]  '!test'
  @return String 'test'
  ###
  _str:(str)->
    str.substr( 1 , str.length)

  ###
  Create options from query
  ###
  opt:->
    if @query
      comma = ''
      for name of @query
        @query[name] = decodeURI @query[name]
        # detect type
        # @type = @detectType name
        if @query[name]
          val = @parse @query[name]
          @where += "#{comma}#{name}#{val}"
          comma = ', '
      console.log @where
    @

  detectType: (name)->
    if @model and @model.schema.path(name)
      # Date Boolean Array
      if @model.schema.path(name).instance is 'undefined'
        if model.schema.path(name).options?.type

          if model.schema.path(name).options.type.name is Date
            return 'Date'

          if model.schema.path(name).options.type.name is Boolean
            return 'Boolean'

          if model.schema.path(name).options.type.name is Array
            return 'Array'

      # Number String ObjectID
      return @model.schema.path(name).instance if @model
    'String'


  ###
  Create sort from query
  ###
  sort:->
    if @query.order
      if @query.order[0] is '-'
        @order = "#{@_str(@query.order)} DESC"
      else
        @order = "#{@query.order}"
      delete @query.order
    @


  ###
  Create limit from query
  ###
  lim:->
    skip = parseInt @query.skip || 0
    delete @query.skip
    limit = parseInt @query.limit || 25
    delete @query.limit
    @limit = "#{skip}, #{limit}"
    @


module.exports = (query)->
  Query.main query


module.exports.Query = Query