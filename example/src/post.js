connection = require './connection'

/**
 * Post model
 */
var Post = connection.model('Post', {});

/**
 * Title of a post
 */
Post.column('title', String);

/**
 * Posted date
 */
Post.column('date', { type: Date });

/**
 * Board where this post belongs to
 */
Post.belongsTo('borad');
