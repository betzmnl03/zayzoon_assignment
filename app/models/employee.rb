class Employee < ApplicationRecord

    belongs_to :employer
    has_many  :earnings

    validates :name, :external_ref, presence: true
    validates :external_ref, uniqueness: { case_sensitive: true }

end
