class Employer < ApplicationRecord

    has_many :employees, dependent: :destroy

    validates :name, :formats, presence: true
end
