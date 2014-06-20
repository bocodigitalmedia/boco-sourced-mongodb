exports.MongoAdapter = require './MongoAdapter'

exports.configure = (config) ->
  new exports.MongoAdapter config
