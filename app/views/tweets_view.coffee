mediator = require 'mediator'
CollectionView = require 'views/collection_view'
TweetView = require 'views/tweet_view'

module.exports = class TweetsView extends CollectionView
  @template = require './templates/tweets'

  tagName: 'div' # This is not directly a list but contains a list
  id: 'tweets'

  containerSelector: '#content-container'
  listSelector: '.tweets' # Append the item views to this element
  fallbackSelector: '.fallback'

  initialize: ->
    super # Will render the list itself and all items
    @subscribeEvent 'loginStatus', @showHideLoginNote
    mediator.subscribe 'sdkLoaded', =>
      twttr.anywhere (T) =>
        @delegate 'click', '.sign-in-button', =>
          T.signIn()

  # The most important method a class inheriting from CollectionView
  # must overwrite.
  getView: (item) ->
    # Instantiate an item view
    new TweetView model: item

  # Show/hide a login appeal if not logged in
  showHideLoginNote: ->
    @$('.login-note').css 'display', if mediator.user then 'none' else 'block'
    @$('.tweets, .tweets-header').css 'display', if mediator.user then 'block' else 'none'

  render: ->
    super
    @showHideLoginNote()
