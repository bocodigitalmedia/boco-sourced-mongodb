ChildProcess = require 'child_process'
async = require 'async'

logger = console
BIN_PATH = "./node_modules/.bin"
COFFEE_PATH = "#{BIN_PATH}/coffee"
MOCHA_PATH = "#{BIN_PATH}/mocha"
MODULE_NAME = require("./package.json").name

exec = (command, done) ->
  logger.log "> #{command}"
  proc = ChildProcess.exec command

  proc.stdout.pipe process.stdout
  proc.stderr.pipe process.stderr

  proc.on "error", (error) -> done error

  proc.on "exit", (code) ->
    if code is 0 then done() else
      done new Error("Process exited with code: #{code}")

rethrow = (error) ->
  throw error if error?

mocha = (args, done) ->
  exec "#{MOCHA_PATH} --compilers coffee:coffee-script #{args}", done

coffee = (args, done) ->
  exec "#{COFFEE_PATH} #{args}", done

testDocs = (done) ->
  coffee "--literate README.md", done

compile = (done) ->
  coffee "--compile --map --output ./package/ ./coffee/", done

linkToGlobal = (done) ->
  exec "npm link", done

linkLocally = (done) ->
  exec "npm link #{MODULE_NAME}", done

link = (done) ->
  async.series [linkToGlobal, linkLocally], done

runSpecs = (done) ->
  mocha "spec/ --reporter spec", done

build = (done) -> async.series [compile, link], done
test = (done) -> async.series [runSpecs, testDocs], done
docs = (done) -> testDocs done
spec = (done) -> runSpecs done

task "test", -> test rethrow
task "build", -> build rethrow
task "spec", -> spec rethrow
task "docs", -> docs rethrow
