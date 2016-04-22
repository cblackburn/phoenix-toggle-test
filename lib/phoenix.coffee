fs = require 'fs'
Path = require 'path'

supportedPathsReg = (paths) ->
  new RegExp("^\/(web|lib|#{paths.join('|')})\/", 'i')

testLibPathsReg = (paths) ->
  new RegExp("^\/(#{paths.join('|')})\/lib\/", 'i')

testWebPathsReg = (paths) ->
  new RegExp("^\/(#{paths.join('|')})\/", 'i')

module.exports =
class Rails
  constructor: (@root, @testPaths, @testDefault) ->

  toggleTestFile: (file) ->
    relativePath = file.substring(@root.length)
    return null unless relativePath.match supportedPathsReg(@testPaths)

    if relativePath.match /_test\.exs$/
      @getElixirFile relativePath
    else
      @findTestFile relativePath

  getElixirFile: (path) ->
    path = path.replace /_test\.exs$/, '.ex'
    path = path.replace testLibPathsReg(@testPaths), '/lib/'
    path = path.replace testWebPathsReg(@testPaths), '/web/'
    Path.join @root, path

  findTestFile: (path) ->
    for testPath in @testPaths
      file = @getTestFile path, testPath
      return file if fs.existsSync file
    @getTestFile path, @testDefault

  getTestFile: (path, testPath) ->
    if path.match /\.ex$/
      path = path.replace /\.ex$/, '_test.exs'
    else
      path = path + '_test.ex'

    if path.match /^\/web\//
      newPath = path.replace /^\/web\//, "/#{testPath}/"
    else
      newPath = path.replace /^\/lib\//, "/#{testPath}/lib/"
    Path.join @root, newPath
