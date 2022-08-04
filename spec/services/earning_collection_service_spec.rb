require 'rails_helper'

RSpec.describe EarningCollectionService, type: :model do

    let!(:new_employer) {
        Employer.create(
            name: "Acme",
            formats:{
                    EmployeeNumber:{name:"external_ref"},
                    CheckDate:{name:"earning_date",pattern:"%m/%d/%Y"},
                    Amount:{name:"amount"}
            })
    }
    let!(:employee1) {Employee.create(
            name:"Betsy", external_ref:"A123",
               employer_id: new_employer.id
    )}

    let!(:employee2){ Employee.create(
            name:"Manuel", external_ref:"B456",
            employer_id: new_employer.id
    )}
  describe '#call' do

    # happy path with valid csv
    it 'should create new earnings records' do
        before_earning = Earning.count 
        EarningCollectionService.new(new_employer, fixture_file_upload('acme_earnings.csv','text/csv')).call
        after_earning = Earning.count
        expect(after_earning).to eq(before_earning+2)
    end

    # invalid external ref i.e employee record doesnt exists
    it 'should fail to retrieve the employee record' do
        before_earning = Earning.count 
        expect{EarningCollectionService.new(new_employer, fixture_file_upload('acme_earnings_invalid_ref.csv','text/csv')).call}.to raise_error(ActiveRecord::RecordNotFound)
        after_earning = Earning.count
        expect(after_earning).to eq(before_earning)
    end
    
    # invalid content type
    it 'should fail to read file and raise Load Error' do
        before_earning = Earning.count 
        expect{EarningCollectionService.new(new_employer, fixture_file_upload('acme_earnings.txt','text/txt')).call}.to raise_error(LoadError)
        after_earning = Earning.count
        expect(after_earning).to eq(before_earning)
    end

     # invalid input date pattern
    it 'should fail to create earning record and raise Date Error' do
        before_earning = Earning.count 
        expect{EarningCollectionService.new(new_employer, fixture_file_upload('acme_earnings_invalid_date.csv','text/csv')).call}.to raise_error(Date::Error)
        after_earning = Earning.count
        expect(after_earning).to eq(before_earning)
    end

  end

  # test the extract_ data private method in the service object
  describe '#extract_data private method' do
    
    # parse valid csv
    it 'should extract data from valid csv' do
        @obj = EarningCollectionService.new(new_employer, fixture_file_upload('acme_earnings.csv','text/csv'))
        result = @obj.send(:extract_data)
        expect(result.length).to eq(2)
    end

    # parse invvalid csv
    it 'should not extract data from invalid file' do
        @obj = EarningCollectionService.new(new_employer, fixture_file_upload('acme_earnings.txt','text/txt'))
        expect{@obj.send(:extract_data)}.to raise_error(LoadError)
    end

  end

  # test the get_employee private method in the service object
  describe '#extract_data private method' do
    let(:service){
        EarningCollectionService.new(new_employer, fixture_file_upload('acme_earnings.txt','text/txt'))
    }
    
    # valid external ref
    it 'should fetch employee id with valid ref' do 
        result = service.send(:get_employee, employee1.external_ref)
        expect(result).to eq(employee1.id)
    end

    # invalid external ref
    it 'should not return employee record' do
        expect{ service.send(:get_employee, employee1.external_ref+employee2.external_ref)}.to raise_error(ActiveRecord::RecordNotFound)
    end

  end

  # test the get_foramtted_date private method in the service object
  describe '#extract_data private method' do
    let(:service){
        EarningCollectionService.new(new_employer, fixture_file_upload('acme_earnings.txt','text/txt'))
    }
    let(:pattern){
        new_employer.formats["CheckDate"]["pattern"]
    }
    # valid date and pattern
    it 'should fetch employee id with valid ref' do
        result =service.send(:get_foramtted_date, "12/12/2021",pattern)
        expect(result).to be_a(Date)
    end

    # invalid date and pattern
    it 'should not return employee record' do
        expect{ service.send(:get_foramtted_date, "25/12/2021",pattern)}.to raise_error(Date::Error)
    end

  end
   
  # test the get_amount private method in the service object
  describe '#extract_data private method' do
    let(:service){
        EarningCollectionService.new(new_employer, fixture_file_upload('acme_earnings.txt','text/txt'))
    }

    # valid string with special characters
    it 'should remove special characters and convert to integer' do
        result =service.send(:get_amount, "$850")
        expect(result).to eq(850*100)
    end

    # valid float
    it 'should not return employee record' do
        result =service.send(:get_amount, "850.90.90")
        expect(result).to eq(850.90*100)
    end

  end
end