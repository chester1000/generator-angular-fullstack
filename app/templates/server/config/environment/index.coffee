'use strict'

path  = require 'path'
_     = require 'lodash'

requiredProcessEnv = (name) ->
  unless process.env[name]
    throw new Error 'You must set the ' + name + ' environment variable'

  process.env[name]

###
  All configurations will extend these options
  ============================================
###
all =
  env: process.env.NODE_ENV

  # Root path of server
  root: path.normalize __dirname + '/../../..'

  # Server port
  port: process.env.PORT or 9000

  # Should we populate the DB with sample data?
  seedDB: true

  # Secret for session, you will want to change this and make it an environment variable
  secrets:
    session: '<%= _.slugify(_.humanize(appname)) + '-secret' %>'

  # List of user roles
  userRoles: ['guest', 'user', 'admin']

  # MongoDB connection options
  mongo:
    options:
      db:
        save: true
<% if(filters.facebookAuth) { %>
  facebook:
    clientID:     process.env.FACEBOOK_ID or 'id'
    clientSecret: process.env.FACEBOOK_SECRET or 'secret'
    callbackURL:  'http://localhost:9000/auth/facebook/callback'
<% } %><% if(filters.twitterAuth) { %>
  twitter:
    clientID:     process.env.TWITTER_ID or 'id'
    clientSecret: process.env.TWITTER_SECRET or 'secret'
    callbackURL:  'http://localhost:9000/auth/twitter/callback'
<% } %><% if(filters.googleAuth) { %>
  google:
    clientID:     process.env.GOOGLE_ID or 'id',
    clientSecret: process.env.GOOGLE_SECRET or 'secret',
    callbackURL:  'http://localhost:9000/auth/google/callback'
<% } %>


###
  Export the config object based on the NODE_ENV
  ==============================================
###
module.exports = _.merge all, require('./' + process.env.NODE_ENV + '.js') or {}









