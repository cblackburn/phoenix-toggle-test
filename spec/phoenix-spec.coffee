Path = require 'path'
Phoenix = require '../lib/phoenix'

describe 'Phoenix', ->
  rootPath = Path.join __dirname, 'fixtures'
  rails = new Phoenix(rootPath, ['test'], 'test')

  describe 'toggleTestFile', ->
    libA       = Path.join rootPath, 'lib/a.ex'
    libATest   = Path.join rootPath, 'test/lib/a_test.exs'
    modelA     = Path.join rootPath, 'web/models/a.ex'
    modelATest = Path.join rootPath, 'test/models/a_test.exs'
    viewA      = Path.join rootPath, 'web/views/a_view.ex'
    viewATest  = Path.join rootPath, 'test/views/a_view_test.exs'

    it 'returns test file for tested file', ->
      expect(rails.toggleTestFile(libA)).toBe libATest
      expect(rails.toggleTestFile(modelA)).toBe modelATest
      expect(rails.toggleTestFile(viewA)).toBe viewATest

    it 'returns tested file for test file', ->
      expect(rails.toggleTestFile(libATest)).toBe libA
      expect(rails.toggleTestFile(modelATest)).toBe modelA
      expect(rails.toggleTestFile(viewATest)).toBe viewA

    it 'returns null for not ruby file', ->
      expect(rails.toggleTestFile('/f/rails/web/test.json')).toBeNull()

    it 'returns null for ruby file not in web or lib or test folder', ->
      expect(rails.toggleTestFile('/f/rails/config/application.rb')).toBeNull()
