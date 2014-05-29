ChildProcess = require 'child_process'
async = require 'async'

logger = console
COFFEE_PATH = "./node_modules/.bin/coffee"
MODULE_NAME = require("./package.json").name

exec = (command, done) ->
  logger.log "> #{command}"
  proc = ChildProcess.exec command

  proc.stdout.pipe process.stdout
  proc.stderr.pipe process.stderr

  proc.on "error", (error) ->
    done error

  proc.on "exit", (code) ->
    if code is 0 then done() else
      done new Error("Process exited with code: #{code}")

rethrow = (error) ->
  throw error if error?

coffee = (args, done) ->
  exec "#{COFFEE_PATH} #{args}", done

test = (done) ->
  coffee "--literate README.md", done

compile = (done) ->
  coffee "--compile --map --output ./package/ ./coffee/", done

linkToGlobal = (done) ->
  exec "npm link", done

linkLocally = (done) ->
  exec "npm link #{MODULE_NAME}", done

task "test", ->
  async.series [compile, linkToGlobal, linkLocally, test], rethrow
