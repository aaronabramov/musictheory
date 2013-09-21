express    = require 'express'
routes     = require './routes'
http       = require 'http'
path       = require 'path'
partials   = require 'express-partials'
browserify = require 'browserify-middleware'
{cssMiddleware} = require './modules/css'
clientBundle = require './modules/client_bundle'

app = express()

app.engine('hamlc', require('haml-coffee').__express)
app.use(partials())



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
  app.use(cssMiddleware)
  app.use(express.static(path.join(__dirname, 'public')))

app.configure 'development', ->
  app.use(express.errorHandler())

app.get '/bundle.js', (req, res) ->
  res.setHeader 'content-type', 'text/javascript'
  clientBundle.bundle (bundle) -> bundle.pipe(res)

app.get '/', routes.index

http.createServer(app).listen app.get('port'), ->
  console.log("Express server listening on port " + app.get('port'))
