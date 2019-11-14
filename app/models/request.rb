class Request < ApplicationRecord
  belongs_to :webhook
  belongs_to :campaign
  has_one :tag
end
