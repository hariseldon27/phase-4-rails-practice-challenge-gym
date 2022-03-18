class Membership < ApplicationRecord
  belongs_to :gym
  belongs_to :client

  validates :gym_id, uniqueness: {scope: :client_id, message: "Client can only have one membership to a gym"}

end
