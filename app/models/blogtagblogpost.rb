
# == Schema Information
#
# Table name: ctagchronicles
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  chronicle_id :bigint
#  ctag_id      :bigint
#
# Indexes
#
#  index_ctagchronicles_on_chronicle_id  (chronicle_id)
#  index_ctagchronicles_on_ctag_id       (ctag_id)
#
class Ctagchronicle < ApplicationRecord
  belongs_to :chronicle
  belongs_to :ctag
end
