SourcedAdapter = exports
SourcedAdapter.MongoAdapter = require './MongoAdapter'

SourcedAdapter.configure = (config) ->
  new exports.MongoAdapter config
