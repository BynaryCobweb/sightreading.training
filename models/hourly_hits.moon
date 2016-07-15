db = require "lapis.db"
import Model, enum from require "lapis.db.model"

import insert_on_conflict_update from require "helpers.models"

class HourlyHits extends Model
  @types: enum {
    hit: 1
    miss: 2
  }

  @relations: {
    {"user", belongs_to: "Users"}
  }

  @increment: (user_id, t, count=1) =>
    t = @types\for_db t

    insert_on_conflict_update @, {
      user_id: assert user_id, "missing user id"
      type: t
      hour: db.raw "default"
    }, {
      :count
    }, {
      count: db.raw "#{db.escape_identifier @table_name!}.count + excluded.count"
    }

