boco-sourced-mongodb
================================================================================

[MongoDB] Storage Adapter for [boco-sourced].

Installation
--------------------------------------------------------------------------------

Install for [node] using [npm]:

```
npm install boco-sourced-mongodb
```

MongoDB Schema
--------------------------------------------------------------------------------
Before using the adapter, you'll want to modify the schema as follows:

```js
db.revisions.ensureIndex({ resourceType: 1, resourceId: 1, resourceVersion: 1 }, { unique: true })
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

### config.connectionString
Use the MongoDB [connection string format] to specify a connection to the database.

    config.connectionString = "mongodb://localhost/sourcedExamples"

### config.revisionsCollectionName
Specify the MongoDB collection name for revisions.

    config.revisionsCollectionName = "revisions"


Create an adapter instance
--------------------------------------------------------------------------------
To create an instance of the adapter, pass in the `config` object to the module's `configure` method:

    adapter = MongoAdapter.configure config


Configure boco-sourced with the adapter
--------------------------------------------------------------------------------
The adapter can now be used by [boco-sourced]:

    Sourced = require 'boco-sourced'
    sourced = Sourced.createService storage: adapter



[connection string format]: http://mongodb.github.io/node-mongodb-native/driver-articles/mongoclient.html#the-url-connection-format

[boco-sourced]: http://github.com/bocodigitalmedia/boco-sourced
[node]: http://nodejs.org
[npm]: http://npmjs.org
[mongodb]: http://mongodb.com
[when]: http://github.com/cujojs/when
