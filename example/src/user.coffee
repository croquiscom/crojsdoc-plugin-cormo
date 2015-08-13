cormo = require 'cormo'

##
# User model
class User extends cormo.Model
  @index age: 1

  ##
  # The name of the user
  @column 'name', String

  ##
  # The age of the user
  @column 'age', type: cormo.types.Integer, required: true

  ##
  # The team where the user belongs to
  @belongsTo 'team'
