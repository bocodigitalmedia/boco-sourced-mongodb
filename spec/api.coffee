Sourced = require 'boco-sourced'
MongoDB = require 'mongodb'
SourcedAdapter = require 'boco-sourced-mongodb'
assert = require 'assert'
async = require 'async'

p1 = '482755e0-2e72-470a-8a36-08a6171b5a5f'
p2 = 'a1ebab41-1b1a-46d1-8935-daca9b58854f'

describe "Sourced MongoDB Storage Adapter", ->

  $config =
    connectionString: "mongodb://localhost/sourced-mongodb-examples"
    revisionsCollectionName: "revisions"

  $adapter = SourcedAdapter.configure $config
  $sourced = Sourced.createService storage: $adapter
  $db = null

  before (done) ->

    MongoDB.connect $config.connectionString, (err, db) ->
      throw err if err?
      $db = db
      $db.collection('revisions').remove null, null, done

  describe "storing a revision", ->

    it "inserts a document into the collection", (done) ->
      p1r0 = $sourced.createRevision 'Post', p1, 0
      p1r0.addEvent 'Drafted', title: 'My First Post'

      $adapter.storeRevision p1r0, (error) ->
        throw error if error?
        query = resourceType: 'Post', resourceId: p1, resourceVersion: 0
        $db.collection('revisions').findOne query, (error, doc) ->
          throw error if error?
          assert.equal 1, doc.events.length
          assert.equal 'Drafted', doc.events[0].type
          assert.equal 'My First Post', doc.events[0].payload.title
          done()

    it "does not store conflicting revisions", (done) ->
      p1r0 = $sourced.createRevision 'Post', p1, 0
      p1r0.addEvent 'Drafted', title: 'Conflicting Draft'
      $adapter.storeRevision p1r0, (error) ->
        assert error instanceof Sourced.RevisionConflict
        done()

  describe "finding revisions", ->

    before (done) ->

      store1 = (done) ->
        rev0 = $sourced.createRevision 'Post', p2, 0
        rev0.addEvent 'Drafted', title: 'My First Post'
        $adapter.storeRevision rev0, done

      store2 = (done) ->
        rev1 = $sourced.createRevision 'Post', p2, 1
        rev1.addEvent 'Published', author: 'John Doe'
        $adapter.storeRevision rev1, done

      async.series [store1, store2], done

    it "finds all revisions for a resource", (done) ->
      $adapter.findRevisions 'Post', p2, (error, revisions) ->
        throw error if error?
        assert.equal 2, revisions.length
        done()
