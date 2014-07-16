'use strict'

mongoose  = require 'mongoose'
{Schema}  = mongoose

ThingSchema = new Schema
  name: String
  info: String
  active: Boolean

module.exports = mongoose.model 'Thing', ThingSchema