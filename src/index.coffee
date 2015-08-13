inflect = require 'inflect'

exports.externalTypes =
  Model: 'http://croquiscom.github.io/cormo/classes/Model.html'
  RecordID: 'http://croquiscom.github.io/cormo/classes/ptypes.RecordID.html'
  Integer: 'http://croquiscom.github.io/cormo/classes/ptypes.Integer.html'
  GeoPoint: 'http://croquiscom.github.io/cormo/classes/ptypes.GeoPoint.html'
  'cormo.Model': 'http://croquiscom.github.io/cormo/classes/Model.html'
  'cormo.types.RecordID': 'http://croquiscom.github.io/cormo/classes/ptypes.RecordID.html'
  'cormo.types.Integer': 'http://croquiscom.github.io/cormo/classes/ptypes.Integer.html'
  'cormo.types.GeoPoint': 'http://croquiscom.github.io/cormo/classes/ptypes.GeoPoint.html'

onCommentCoffeeScript = (comment) ->
  if /^@column\s+['"]([^'"]+)['"]\s*,\s+(.*)/.test comment.code
    path = RegExp.$1
    property = RegExp.$2.trim()
    comment.tags.push type: 'property', name: path
    if /^([A-Za-z.]+)$/.test(property) or /type\s*:\s*([A-Za-z.]+)/.test property
      type = RegExp.$1.replace /cormo\.types\./, ''
      comment.tags.push type: 'type', typeString: type
  else if /^@belongsTo\s+['"]([^'"]+)['"]/.test comment.code
    name = RegExp.$1
    target_model = inflect.camelize name
    comment.tags.push type: 'property', name: name+'_id'
    comment.tags.push type: 'type', typeString: target_model

onCommentJavaScript = (comment) ->
  if /\bconnection.model\s*\(\s*['"]([^'"]+)['"],/.test comment.code
    comment.tags.push type: 'class', string: RegExp.$1
  else if /([A-Za-z0-9_]+)\.column\s*\(\s*['"]([^'"]+)['"]\s*,\s*(.*)/.test comment.code
    model = RegExp.$1
    path = RegExp.$2
    property = RegExp.$3
    comment.tags.push type: 'memberof', parent: model+'::'
    comment.tags.push type: 'property', name: path
    if /^([A-Za-z.]+)/.test(property) or /type:\s*([A-Za-z.]+)/.test property
      type = RegExp.$1.replace /cormo\.types\./, ''
      comment.tags.push type: 'type', typeString: type
  else if /([A-Za-z0-9_]+)\.belongsTo\s*\(\s*['"]([^'"]+)['"]/.test comment.code
    model = RegExp.$1
    name = RegExp.$2
    target_model = inflect.camelize name
    comment.tags.push type: 'memberof', parent: model+'::'
    comment.tags.push type: 'property', name: name+'_id'
    comment.tags.push type: 'type', typeString: target_model

exports.onComment = (comment) ->
  if comment.language is 'coffeescript'
    onCommentCoffeeScript comment
  else if comment.language is 'javascript'
    onCommentJavaScript comment
