'use strict'

passport  = require 'passport'
jwt       = require 'jsonwebtoken'
User      = require './user.model'
config    = require '../../config/environment'


validationError = (res, err) ->
  res.json 422, err


# Get list of users (restriction: 'admin')
exports.index = (req, res) ->
  User.find {}, '-salt -hashedPassword', (err, users) ->
    return res.send 500, err if err
    res.json 200, users

# Create new user
exports.create = (req, res, next) ->
  newUser = new User req.body
  newUser.provider = 'local'
  newUser.role = 'user'
  newUser.save (err, user) ->
    return validationError res, err if err
    token = jwt.sign _id:user._id, config.secrets.session, expiresInMinutes:5*60
    res.json token:token

# Get a single user
exports.show = (req, res, next) ->
  User.findById req.params.id, (err, user) ->
    return next err if err
    return res.send 401 unless user
    res.json user.profile

# Deletes a user (restriction: 'admin')
exports.destroy = (req, res) ->
  User.findByIdAndRemove req.params.id, (err, user) ->
    return res.send 500, err if err
    res.send 204

# Change user's password
exports.changePassword = (req, res, next) ->
  userId = req.user._id
  oldPass = String req.body.oldPassword
  newPass = String req.body.newPassword

  User.findById userId, (err, user) ->
    return next err if err
    return res.send 403 unless user.authenticate oldPass

    user.password = newPass
    user.save (err) ->
      return validationError res, err if err
      res.send 200

# Get my info
exports.me = (req, res, next) ->
  User.findOne _id:req.user._id, '-salt -hashedPassword', (err, user) ->
    return next err if err
    return res.json 401 unless user
    res.json user

# Authenticate callback
exports.authCallback = (req, res, next) ->
  res.redirect '/'
