Phoenix = require './phoenix'

module.exports =
  config:
    testSearchPaths:
      type: 'array'
      default: ['test']
    testDefaultPath:
      type: 'string'
      default: 'test'

  activate: (state) ->
    atom.commands.add 'atom-text-editor',
      'phoenix-toggle-test:toggle': (event) => @toggleTestFile()

  toggleTestFile: ->
    editor = atom.workspace.getActiveTextEditor()
    testPaths = atom.config.get 'phoenix-toggle-test.testSearchPaths'
    testDefault = atom.config.get 'phoenix-toggle-test.testDefaultPath'
    root = atom.project.getPaths()[0]
    file = new Phoenix(root, testPaths, testDefault).toggleTestFile(editor.getPath())
    atom.workspace.open(file) if file?
