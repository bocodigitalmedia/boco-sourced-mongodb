boco-sourced-mongodb
================================================================================

[MongoDB] Storage Adapter for [boco-sourced].

Installation
--------------------------------------------------------------------------------

Install for [node] using [npm]:

```
npm install boco-sourced-mongodb
```

Usage
================================================================================

For the examples below, we'll need the adapter module:

    MongoAdapter = require 'boco-sourced-mongodb'

We'll use the `assert` module to demonstrate behavior:

    assert = require 'assert'

Configuration
--------------------------------------------------------------------------------
Let's create a configuration object for our adapter:

    config = {}


Create an adapter instance
--------------------------------------------------------------------------------
To create an instance of the adapter, pass in the `config` object to the module's `configure` method:

    adapter = MongoAdapter.configure config

Configure boco-sourced with the adapter
--------------------------------------------------------------------------------
The adapter can now be used by [boco-sourced]:

    Sourced = require 'boco-sourced'
    sourced = Sourced.createService storage: adapter

---

API
================================================================================


Storing revisions
--------------------------------------------------------------------------------
The adapter stores revisions to the database.

    userId = '482755e0-2e72-470a-8a36-08a6171b5a5f'
    revision = sourced.createRevision 'User', userId

    adapter.storeRevision revision, (error) ->
      throw error if error?

Finding revisions
--------------------------------------------------------------------------------
The adapter finds revisions by the resource `type` and `id`.

    adapter.findRevisions 'User', userId, (error, revisions) ->
      throw error if error?
      assert.equal 3, revisions.length

[boco-sourced]: http://github.com/bocodigitalmedia/boco-sourced
[node]: http://nodejs.org
[npm]: http://npmjs.org
[mongodb]: http://mongodb.com
