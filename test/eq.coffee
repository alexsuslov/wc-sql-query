query = require("../coffee/index")
assert = require("assert")

# mongoose = require('mongoose')
# Schema = mongoose.Schema
# ObjectId = Schema.Types.ObjectId

# model = mongoose.model 'test', new Schema
#   str: String
#   num: Number
#   dat: Date
#   bl: Boolean
#   ar: Array
#   obId: ObjectId
#   t:
#     id:Number


describe "Query", ->
#   describe "#OR /?name=+", ->
#     it "should return { name: { '$exists': true } }",->
#       opt = query name:'+'
#       assert.equal  true, opt.conditions.name['$exists']

#   describe "#OR /?name=-", ->
#     it "should return { name: { '$exists': false } }",->
#       opt = query name:'-'
#       assert.equal  false, opt.conditions.name['$exists']



#   describe "#OR /?or='name=3,test=4", ->
#     it "should return { '$or': [ { name: '3' }, { test: [Object] } ] }", ->
#       opt = query "or":'name=3,test=!4'
#       # console.log opt.conditions
#       assert.equal  3, opt.conditions['$or'][0].name
#       assert.equal  4, opt.conditions['$or'][1].test['$ne']

#   # $AND
#   # /?or='name=3,test=4'

#   describe "#AND /?and='name=3,test=!4", ->
#     it "should return { '$and': [ { name: '3' }, { test: [Object] } ] }", ->
#       opt = query "and":'name=3,test=!4'
#       # console.log opt
#       assert.equal  3, opt.conditions['$and'][0].name
#       assert.equal  4, opt.conditions['$and'][1].test['$ne']


#   ###
#   # Sort
#   ###
#   # /api/item?order=name
  describe "#SORT order=name", ->
    it "should return options: order: name: 1", ->
      opt = query order:"name"
      assert.equal  'name', opt.order

  # /api/item?order=-name
  describe "#SORT order=-name", ->
    it "should return options: order: name: 1", ->
      opt = query order:"-name"
      assert.equal  'name DESC', opt.order

#   ###
#   # Limit
#   ###
#   # /api/item?limit=50&skip=50
  describe "#LIMIT limit=50 & skip=100", ->
    it "should return options: 100, 50", ->
      opt = query
        limit: 50
        skip: 100
#       # console.log opt
      assert.equal  '100, 50', opt.limit



  ###
  #
  # Evaluation Query Operators
  #
  ###
  # describe "#REGEX name=~test", ->
  #   it "should return conditions: name: $regex: 'test'", ->
  #     opt = query name:"~test"
  #     # console.log opt
  #     assert.equal  'test', opt.conditions.name["$regex"]
  ###
  #
  #   Comparison Query Operators
  #
  ###
  describe "#EQ name=test", ->
    it "should return { where: name='test'}", ->
      opt = query name:"test"
      assert.equal  "name='test'", opt.where
      assert.equal  "0, 25", opt.limit

  describe "#EQ name=test&name1=qwe", ->
    it "should return { where: name='test'}", ->
      opt = query (name:"test",name1:'qwe')
      assert.equal  "name='test', name1='qwe'", opt.where

  describe "#NEQ name=!test", ->
    it "should return { conditions: 'name:$ne:test'", ->
      opt = query name:"!test"
      assert.equal  "name!='test'", opt.where

  describe "#GT name>3", ->
    it "should return name>'3'", ->
      opt = query name:">3"
      assert.equal  "name>'3'", opt.where

  describe "#GTE name=]3", ->
    it "should return name=>'3'", ->
      opt = query name:"]3"
      # console.log opt
      assert.equal  "name=>'3'", opt.where

  describe "#LT name=<3", ->
    it "should return name<'3'", ->
      opt = query name:"<3"
      # console.log opt
      assert.equal  "name<'3'", opt.where

  describe "#LTE name=<3", ->
    it "should return name<='3'", ->
      opt = query name:"[3"
      # console.log opt
      assert.equal  assert.equal  "name<='3'", opt.where

#   describe "#IN name=@1|2|3", ->
#     it "should return conditions: $in: ['1','2','3'] ", ->
#       opt = query name:"@1|2|3"
#       # console.log opt
#       assert.equal 1, opt.conditions.name['$in'][0]
#       assert.equal 2, opt.conditions.name['$in'][1]
#       assert.equal 3, opt.conditions.name['$in'][2]

#   describe "#NIN name=#1|2|3", ->
#     it "should return conditions: $in: ['1','2','3'] ", ->
#       opt = query name:"#1|2|3"
#       # console.log opt
#       assert.equal 1, opt.conditions.name['$nin'][0]
#       assert.equal 2, opt.conditions.name['$nin'][1]
#       assert.equal 3, opt.conditions.name['$nin'][2]

# describe "Model", ->
#   it "return type", ->
#     query.Query.model = model
#     assert.equal 'String', query.Query.detectType 'str'
#     assert.equal 'Number', query.Query.detectType 'num'
#     assert.equal 'Number', query.Query.detectType 't.id'