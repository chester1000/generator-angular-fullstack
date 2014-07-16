'use strict'

passport          = require 'passport'
TwitterStrategy   = require('passport-twitter').Strategy

exports.setup = (User, config) ->
  passport.use new TwitterStrategy
    consumerKey: config.twitter.clientID
    consumerSecret: config.twitter.clientSecret
    callbackURL: config.twitter.callbackURL

  , (token, tokenSecret, profile, done) ->
    User.findOne
      'twitter.id_str': profile.id

    , (err, user) ->
      return done err if err
      return done null, user if user

      user = new User
        name: profile.displayName
        role: 'user'
        username: profile.username
        provider: 'twitter'
        twitter: profile._json

      user.save (err) ->
        return done err if err
        done null, user