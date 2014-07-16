'use strict'

passport        = require 'passport'
GoogleStrategy  = require('passport-google-oauth').Strategy

exports.setup = (User, config) ->
  passport.use new GoogleStrategy
    clientID: config.google.clientID
    clientSecret: config.google.clientSecret
    callbackURL: config.google.callbackURL

  , (accessToken, refreshToken, profile, done) ->
    User.findOne
      'google.id': profile.id

    , (err, user) ->
      return done err if err
      return done null, user if user

      user = new User
        name: profile.displayName
        email: profile.emails[0].value
        role: 'user'
        username: profile.username
        provider: 'google'
        google: profile._json

      user.save (err) ->
        return done err if err
        done null, user