#  Copyright (c) 2016, hitobito AG. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

class RenameTags < ActiveRecord::Migration[4.2]
  def change
    rename_table :tags, :old_tags
  end
end
