class EmployersController < ApplicationController

    def show
        @employer = Employer.find_by_id(params[:id])
    end

    def employee_earnings 
        begin
            @employer = Employer.find_by_id!(params[:id])
            EarningCollection.call(@employer,params[:file])
            redirect_to employer_path(@employer), notice: "Data Uploaded successfully"
        rescue ActiveRecord::RecordNotFound, Date::Error, LoadError =>e
            handle_error(e,params[:id])
        end
    end

    private
    def handle_error(e,id)
        redirect_to employer_path(id), alert: "Error:"+e.message
    end
end
