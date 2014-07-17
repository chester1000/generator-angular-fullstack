###
  Express configuration
###

'use strict'

express         = require 'express'
favicon         = require 'static-favicon'
morgan          = require 'morgan'
compression     = require 'compression'
bodyParser      = require 'body-parser'
methodOverride  = require 'method-override'
cookieParser    = require 'cookie-parser'
errorHandler    = require 'errorhandler'
path            = require 'path'
config          = require './environment'<% if (filters.auth) { %>
passport        = require 'passport'<% } %><% if (filters.twitterAuth) { %>
session         = require 'express-session'
mongoStore      = require('connect-mongo') session<% } %>

module.exports = (app) ->
  env = app.get 'env'

  app.set  'views', config.root + '/server/views'<% if (filters.html) { %>
  app.engine 'html', require('ejs').renderFile
  app.set 'view engine', 'html'<% } %><% if (filters.jade) { %>
  app.set 'view engine', 'jade'<% } %>
  app.use compression()
  app.use bodyParser.urlencoded extended:false
  app.use bodyParser.json()
  app.use methodOverride()
  app.use cookieParser()<% if (filters.auth) { %>
  app.use passport.initialize()<% } %><% if (filters.twitterAuth) { %>

  # Persist sessions with mongoStore
  # We need to enable sessions for passport twitter because its an oauth 1.0 strategy
  app.use session
    secret: config.secrets.session
    resave: true
    saveUninitialized: true
    store: new mongoStore
      url: config.mongo.uri
      collection: 'sessions'
    , ->
      console.log 'db connection open'<% } %>

  if env is 'production'
    app.use favicon path.join config.root, 'public', 'favicon.ico'
    app.use express.static path.join config.root, 'public'
    app.set 'appPath', path.join config.root, 'public'
    app.use morgan 'dev'

  if env is 'development' or env is 'test'
    app.use require('connect-livereload')()
    app.use express.static path.join config.root, '.tmp'
    app.use express.static path.join config.root, 'client'
    app.set 'appPath', 'client'
    app.use morgan 'dev'
    app.use errorHandler() # Error handler - has to be last