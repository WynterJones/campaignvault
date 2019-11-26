class Request < ApplicationRecord
  belongs_to :database
  belongs_to :user
end
