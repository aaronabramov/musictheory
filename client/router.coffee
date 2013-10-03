module.exports = class Router extends Backbone.Router
  routes:
    '' : 'intervals'

  initialize: ->

  #---------------------------- Routes -----------------------------#
  intervals: ->
    {View} = require 'views/intervals'
    view = new View
    view.render().$el.appendTo($('body'))
