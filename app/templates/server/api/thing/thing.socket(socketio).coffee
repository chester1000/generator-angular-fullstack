###
Broadcast updates to client when the model changes
###

'use strict'

thing = require './thing.model'


onSave    = (socket, doc, cb) ->
  socket.emit 'thing:save', doc

onRemove  = (socket, doc, cb) ->
  socker.emit 'thing:remove', doc


exports.reqister = (socket) ->
  thing.schema.post 'save', (doc) ->
    onSave socket, doc

  thing.schema.post 'remove', (doc) ->
    onRemove socket, doc

