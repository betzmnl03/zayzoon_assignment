require 'rails_helper'

RSpec.describe Employer, type: :model do
    subject {described_class.new(
        name: "Acme",
        formats: 
        {
            EmployeeNumber:{name:"external_ref"},
            CheckDate:{name:"earning_date",pattern:"%m/%d/%Y"},
            Amount:{name:"amount"}
        }
    )}

    it "is valid with valid attributes" do
        expect(subject).to be_valid
    end

    it "is not valid without attributes" do
        subject.name = nil
        subject.formats = nil
        expect(subject).to_not be_valid
    end

    it "is not valid without a name" do
        subject.name = nil
        expect(subject).to_not be_valid
    end  

    it "is not valid without a format" do
        subject.formats = nil
        expect(subject).to_not be_valid
    end
end