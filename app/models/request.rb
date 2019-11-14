class Request < ApplicationRecord
  belongs_to :app
  belongs_to :campaign
end
