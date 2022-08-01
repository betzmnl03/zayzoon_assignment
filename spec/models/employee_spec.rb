require 'rails_helper'

RSpec.describe Employee, type: :model do

    let(:employer) {Employer.create(
        name:"Acme",
        formats:{
            EmployeeNumber:{name:"external_ref"},
            CheckDate:{name:"earning_date",pattern:"%m/%d/%Y"},
            Amount:{name:"amount"}
        }
    )}
    subject {described_class.new(
        name: "Betsy",
        external_ref: "A123",
        employer_id: employer.id
    )}

    describe "AttributeValidations" do 
        it "is valid with valid attributes" do
            expect(subject).to be_valid
        end

        it "is not valid without attributes" do
            subject.name = nil
            subject.external_ref = nil
            subject.employer_id = nil
            expect(subject).to_not be_valid
        end

        it "is not valid without a name" do
            subject.name = nil
            expect(subject).to_not be_valid
        end  

        it "is not valid without an external_ref" do
            subject.external_ref = nil
            expect(subject).to_not be_valid
        end

        it "is not valid without an employer_id" do
            subject.employer_id = nil
            expect(subject).to_not be_valid
        end
    end

    describe "Associations" do
        it {should belong_to(:employer)}
    end

    describe "Validations" do
        it { should validate_presence_of(:employer) }
        it { should validate_uniqueness_of(:external_ref) }
    end
end