require 'rails_helper'


RSpec.describe EmployersController, type: :controller do

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

    describe "#show_employer" do 
        it "should show employer" do
            get :show, params:{id: new_employer.id}
            assert_response :success
        end

        it "should render the show page" do
            get :show, params:{id: new_employer.id}
            expect(response).to render_template(:show)
        end
    end
    
    describe '#employee_earnings' do
       
        # happy-path
        it 'should successfully import csv' do
           post :employee_earnings, params: {id: new_employer.id, file:fixture_file_upload('acme_earnings.csv','text/csv')}
           expect(response).to redirect_to(employer_path(new_employer.id))
        end
        
        # invalid content type
        it 'should fail to read file' do
            post :employee_earnings, params: {id:new_employer.id, file:fixture_file_upload('acme_earnings.txt','text/txt')}
            expect(response).to redirect_to(employer_path(new_employer.id))
        end

        # invalid external ref i.e employee record doesnt exists
        it 'should fail to retrieve the employee record' do
            post :employee_earnings, params: {id:new_employer.id, file:fixture_file_upload('acme_earnings_invalid_ref.csv','text/csv')}
            expect(response).to redirect_to(employer_path(new_employer.id))
        end

        # invalid input date pattern
        it 'should fail to create earning record' do
            post :employee_earnings, params: {id:new_employer.id, file:fixture_file_upload('acme_earnings_invalid_date.csv','text/csv')}
            expect(response).to redirect_to(employer_path(new_employer.id))
        end

        # amount with special characters
        it 'should convert to valid amount in cents' do
            post :employee_earnings, params: {id:new_employer.id, file:fixture_file_upload('acme_earnings_invalid_amount.csv','text/csv')}
            expect(response).to redirect_to(employer_path(new_employer.id))
        end
  


    end

    # test to check whether service object is invoked
    describe "#call" do
        let(:file){
            fixture_file_upload('acme_earnings.csv','text/csv')
        }

        it "invokes the service object" do
            expect(EarningCollectionService).to receive(:call)
            post :employee_earnings, params: {id: new_employer.id, file:file}
        end
    end

end
