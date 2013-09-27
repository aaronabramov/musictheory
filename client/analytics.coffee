module.exports = class Analytics
  # @param option [String] env current environment.
  constructor: ({@env} = {})->
    # if @env is "production"
    @initGA()
    # else
    #   # Development stub
    #   window.ga = ->

  # @return [Object] key as GA demension key, value as dimension value.
  # @example:
  #         # dimension1: @user?.get('email')
  dimensions: ->

  # GA default analytics.js code snipped.
  #   excluding page tracking.
  # @see router#_trackPageview for page trackings
  initGA: ->
    ((i, s, o, g, r, a, m) ->
      i["GoogleAnalyticsObject"] = r
      i[r] = i[r] or ->
        (i[r].q = i[r].q or []).push arguments

      i[r].l = 1 * new Date()

      a = s.createElement(o)
      m = s.getElementsByTagName(o)[0]

      a.async = 1
      a.src = g
      m.parentNode.insertBefore a, m
    ) window, document, "script", "//www.google-analytics.com/analytics.js", "ga"

    ga "create", 'UA-44395212-1', 'musictheory.me'
    @setDimensions()

  setDimensions: ->
    return unless @dimensions()
    for name, dimension of @dimensions()
      ga 'set', name, dimension

  # Send tracking info to GA.
  trackPageview: ->
    window.ga 'send', 'pageview'
