class EarningsController < ApplicationController


    def employee_earnings 
        @employer = Employer.find_by_id(params[:id])

        test = EarningCollection.new(@employer)
        result = test.injectData(params[:file])

    end
end
