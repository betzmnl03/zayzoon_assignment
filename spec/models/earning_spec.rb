require 'rails_helper'

RSpec.describe Earning, type: :model do

    let(:employer) {Employer.create(
        name:"Acme",
        formats:{
            EmployeeNumber:{name:"external_ref"},
            CheckDate:{name:"earning_date",pattern:"%m/%d/%Y"},
            Amount:{name:"amount"}
        }
    )}
    let(:employee){
        Employee.create(
            name: "Betsy",
            external_ref: "A123",
            employer_id: employer.id
        )
    }
    subject {described_class.new(
        amount: 800,
        earning_date:DateTime.new(),
        employee_id: employee.id
    )}

    describe "AttributeValidations" do 
        it "is valid with valid attributes" do
            expect(subject).to be_valid
        end

        it "is not valid without attributes" do
            subject.amount = "bbjbk"
            subject.earning_date = "mklnmlk"
            subject.employee_id = nil
            expect(subject).to_not be_valid
        end

        it "is not valid without a amount" do
            subject.amount = nil
            expect(subject).to_not be_valid
        end  

        it "is not valid without an earning date" do
            subject.earning_date = nil
            expect(subject).to_not be_valid
        end

        it "is not valid without an employee_id" do
            subject.employee_id = nil
            expect(subject).to_not be_valid
        end
    end

    describe "Associations" do
        it {should belong_to(:employee)}
    end

    describe "Validations" do
        it { should validate_presence_of(:employee) }
        it { should validate_numericality_of(:amount) }
    end
end