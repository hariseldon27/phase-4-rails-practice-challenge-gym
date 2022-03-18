class Client < ApplicationRecord
    has_many :memberships, dependent: :destroy
    has_many :gyms, through: :memberships
    validates :age, numericality: { greater_than: 100}

    def total_memberships_price
        memberships.sum(:charge)
    end
end
