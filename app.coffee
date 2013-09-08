express    = require 'express'
routes     = require './routes'
user       = require './routes/user'
http       = require 'http'
path       = require 'path'
partials   = require 'express-partials'
nib        = require 'nib'
stylus     = require 'stylus'
browserify = require 'browserify-middleware'
coffee     = require 'coffee-script'
through    = require 'through'

app = express()

app.engine('hamlc', require('haml-coffee').__express)
app.use(partials())

# Compile stylus.
compile = (str, path) ->
  stylus(str)
    .set('filename', path)
    .set('compress', true)
    .use(nib())


# Coffeescript transform function.
transform = (file) ->
    data = ''

    write =  (buf) -> data += buf
    end = ->
        @queue(coffee.compile(data))
        @queue(null)
    through(write, end)


app.configure ->
  app.set('port', process.env.PORT || 3002)
  app.set('views', __dirname + '/views')
  app.set('view engine', 'hamlc')
  app.set('layout', 'layout')
  app.use(express.favicon())
  app.use(express.logger('dev'))
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(express.cookieParser('your secret here'))
  app.use(express.session())
  app.use(app.router)
  app.use(stylus.middleware
    src: __dirname + '/public'
    compile: compile
  )
  app.use(express.static(path.join(__dirname, 'public')))

browserify.settings
  transform: [transform]

app.get '/application.js', browserify('./client/application.coffee',)
app.configure 'development', ->
  app.use(express.errorHandler())

app.get('/', routes.index)
app.get('/users', user.list)

http.createServer(app).listen app.get('port'), ->
  console.log("Express server listening on port " + app.get('port'))
