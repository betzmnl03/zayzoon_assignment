class Earning < ApplicationRecord

    belongs_to :employee

    validates :earning_date, presence: true
    validates :amount, presence: true, numericality: { only_integer: true }
 
   
end
