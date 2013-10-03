module.exports = class MusicTheroy
  constructor: ({@env}) ->
    Router = require 'router'
    @router = new Router
    Backbone.history.start pushState: true
