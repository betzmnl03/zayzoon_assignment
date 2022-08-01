# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Earning.delete_all
Employee.delete_all
Employer.delete_all



employers = ["Acme","Beta"]

employers = [
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
    },
    {
        name:"Beta",
        employees:[
            {name:"Rose", external_ref:"123"},
            {name:"Abraham", external_ref:"456"},
        ],
        formats:
            {
            employee:{name:"external_ref"},
            earningDate:{name:"earning_date",pattern:"%Y-%m-%d"},
            netAmount:{name:"amount"}}
    }
]

# employer1

employers.each do |employer|
    new_employer = Employer.create({
       name:employer[:name],
       formats:employer[:formats]
    })
    puts employer
    employer[:employees].each do |employee|
        puts employee
        new_employee = Employee.create({
         **employee,
            employer_id: new_employer.id
        })
        puts "saved", new_employee
    end

end
# employer1 = Employer.create(
#     name:"Acme"
# )

# employer2 = Employer.create(
#     name: "Beta",

# )

# employee_acme1 = Employee.create(
#     name: "Betsy",
#     external_ref: "A123",
#     employer_id: employer1.id
# )


# employee_acme2 = Employee.create(
#     name: "Rose",
#     external_ref: "B456",
#     employer_id: employer1.id
# )

# employee_beta = Employee.create(
#     name: "Florence",
#     external_ref: "123",
#     employer_id: employer2.id
# )

# employee_acme2 = Employee.create(
#     name: "Ruth",
#     external_ref: "456",
#     employer_id: employer2.id
# )