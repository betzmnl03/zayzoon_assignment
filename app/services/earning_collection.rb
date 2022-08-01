require "csv"
class EarningCollection < ApplicationService

    def initialize(employer, file)
        @employer = employer
        @file = file
    end

    def call
      ActiveRecord::Base.transaction do  
      extracted_data = extract_data()
      earnings_arr = []
      extracted_data.each do |earning|
        new_earning = Earning.new()
          @employer.formats.each do |format, value|
            if value["name"] == "external_ref"
              new_earning.employee_id  = get_employee(earning[format])
            elsif value["name"] == "earning_date"
              new_earning.earning_date = get_foramtted_date(earning[format],value["pattern"]) 
            else
              new_earning.amount = get_amount(earning[format])
            end
          end
          new_earning.save!
        end
      end
    end


  private 
    def extract_data()
      file_details = []
      if @file.content_type != "text/csv"
        raise LoadError.new("Please upload a csv file")
      end
      CSV.foreach(@file, headers: true) do |row|
        file_details << row.to_h
      end
      file_details
    end

    def get_employee(external_ref)
      existing_employee = Employee.find_by!(external_ref: external_ref)
      return existing_employee.id
    end


    def get_foramtted_date(string, pattern)
      return DateTime.strptime(string,pattern).to_date 
    end


    def get_amount(raw_amount)
      formatted_amount = raw_amount.gsub(/[^0-9.]/, '')
      amount = (formatted_amount.to_d * 100).to_i
    end
end