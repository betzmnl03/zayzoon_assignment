require 'rails_helper'


RSpec.describe EmployersController, type: :controller do
    describe '#employee_earnings' do
        before do
            @employer =
                {
                    name:"Acme",
                    employees:[
                        {name:"Betsy", external_ref:"A123"},
                        {name:"Manuel", external_ref:"B456"},
                    ],
                    formats:
                        {
                            EmployeeNumber:{name:"external_ref"},
                            CheckDate:{name:"earning_date",pattern:"%m/%d/%Y"},
                            Amount:{name:"amount"}}
                }
            @new_employer = Employer.create({
                    name: @employer[:name],
                    formats:@employer[:formats]
                })
            @employer[:employees].each do |employee|
                new_employee = Employee.create({
                 **employee,
                    employer_id: @new_employer.id
                })
                
            end
        end
        # happy-path
        it 'should successfully import csv' do
           post :employee_earnings, params: {id:@new_employer.id, file:fixture_file_upload('acme_earnings.csv','text/csv')}
           expect(response).to redirect_to(employer_path(@new_employer.id))
           expect(flash[:notice]).to match("Data Uploaded successfully")
        end
        
        # happy-path
        it 'should create earnings records' do
            before_earning = Earning.count 
            post :employee_earnings, params: {id:@new_employer.id, file:fixture_file_upload('acme_earnings.csv','text/csv')}
            after_earning = Earning.count
            expect(after_earning).to eq(before_earning+2)
        end

        # invalid content type
        it 'should fail to read file' do
            post :employee_earnings, params: {id:@new_employer.id, file:fixture_file_upload('acme_earnings.txt','text/txt')}
            expect(response).to redirect_to(employer_path(@new_employer.id))
            expect(flash[:alert]).to match("Please upload a csv file")
        end

        # invalid external ref i.e employee record doesnt exists
        it 'should fail to retrieve the employee record' do
            post :employee_earnings, params: {id:@new_employer.id, file:fixture_file_upload('acme_earnings_invalid_ref.csv','text/csv')}
            expect(response).to redirect_to(employer_path(@new_employer.id))
            expect(flash[:alert]).to match("Error:Couldn't find Employee")
        end

        # invalid input date pattern
        it 'should fail not create earning record' do
            post :employee_earnings, params: {id:@new_employer.id, file:fixture_file_upload('acme_earnings_invalid_date.csv','text/csv')}
            expect(response).to redirect_to(employer_path(@new_employer.id))
            expect(flash[:alert]).to match("Error:invalid date")
        end

        # amount with special characters
        it 'should convert to valid amount in cents' do
            post :employee_earnings, params: {id:@new_employer.id, file:fixture_file_upload('acme_earnings_invalid_amount.csv','text/csv')}
            expect(response).to redirect_to(employer_path(@new_employer.id))
            expect(flash[:notice]).to match("Data Uploaded successfully")
        end

        # if an error occurs mid way, should rollback the transaction
        it 'should rollback the fist record' do
            before_earning = Earning.count 
            post :employee_earnings, params: {id:@new_employer.id, file:fixture_file_upload('acme_earnings_rollback.csv','text/csv')}
            after_earning = Earning.count
            expect(after_earning).to eq(before_earning)
        end

    end
end
