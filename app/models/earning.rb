class Earning < ApplicationRecord

    belongs_to :employee

    validates :earning_date, :amount, :employee, presence: true
    validates :amount, numericality: { only_integer: true }
  
end
