GoToDefinitionRailsView = require './go-to-definition-rails-view'
{CompositeDisposable} = require 'atom'

module.exports = GoToDefinitionRails =
  subscriptions: null
  finder: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'go-to-definition-rails:goToDefinition': => @goToDefinition()

  deactivate: ->
    @subscriptions.dispose()
    @finder.cancel() if @finder?

  goToDefinition: ->
    workspace = atom.workspace
    editor = workspace.getActivePaneItem()
    current_word = editor.getWordUnderCursor()

    @finder.cancel() if @finder?

    @finder = finder = atom.workspace.defaultDirectorySearcher.search(atom.project.rootDirectories, ///def\s+(self\.)?#{current_word}///, {
      inclusions: ['*.rb']
      didMatch: (searchResult) ->
        workspace.open(searchResult.filePath, { initialLine: searchResult['matches'][0].range[0][0] })
        finder.cancel()
      didError: () ->
      didSearchPaths: () ->
    })
