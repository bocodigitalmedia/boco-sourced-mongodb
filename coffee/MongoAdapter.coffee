Sourced = require 'boco-sourced'
MongoJS = require 'mongojs'

module.exports = class MongoStorage extends Sourced.AbstractStorage

  constructor: (config = {}) ->
    @connectionString = config.connectionString
    @revisionsCollectionName = config.revisionsCollectionName

  getDatabase: ->
    return @db if @db?
    @db = MongoJS @connectionString

  getRevisionsCollection: ->
    return @revisionsCollection if @revisionsCollection?
    @revisionsCollection = @getDatabase().collection @revisionsCollectionName

  storeRevision: (revision, callback) ->
    collection = @getRevisionsCollection()
    collection.insert revision, (error) ->
      return callback() unless error?
      return callback(error) unless error.code is 11000
      callback new Sourced.RevisionConflict()

  findRevisions: (resourceType, resourceId, callback) ->
    collection = @getRevisionsCollection()
    query = resourceType: resourceType, resourceId: resourceId
    collection.find(query).toArray (error, results) ->
      callback error, results
