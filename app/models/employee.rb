class Employee < ApplicationRecord

    belongs_to :employer
    has_many  :earnings, dependent: :destroy

    validates :name, :external_ref, :employer, presence: true
    validates :external_ref, uniqueness: { case_sensitive: true }

end
