'use strict'

express   = require 'express'
passport  = require 'passport'
auth      = require '../auth.service'


localStrategy = passport.authenticate 'local', (err, user, info) ->
  error = err or info
  return res.json 401, error if error
  unless user
    return res.json 404, message: 'Something went wrong, please try again.'

  token = auth.signToken user._id, user.role
  res.json token:token


router = express.Router()

router.post '/', (req, res, next) ->
  localStrategy req, res, next


module.exports = router