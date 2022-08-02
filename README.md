# README

# ASSESSMENT

## Assumptions

- I assumed the Employer and Employee records would already exist in the db and hence can just navigate to the url employers/:id to upload the csv file.

- I also asssumed that the check date in all the csv is in UTC hence saving it without the offset.

## API Structure

- Created a custom route inside Employers Controller since the csv will be uploaded by the employer.
- Wrapped the logic inside the service object in a transaction since if something goes wrong mid way while processing and saving the data from the csv, it should rollback all the changes. This will prevent duplicate records from being created if the employer tries to upload again.
- Added private methods to process each part of the csv and raise exceptions when necessary
- Wrapped the controller logic inside begin and rescue block for error handling. The reason being, I would like to display the failure reason to the user so they can fix the csv and retry.
- Added validations to all the models.

## Tests

- Added controller tests
- Added model tests

# GETTING STARTED

## To bring up the environment, perform the following steps:

1. bundle install
2. rails db:create
3. rails db:migrate
4. rails db:seed
5. rails s

## To upload earnings csv

1. To upload acme earnings.csv, navigate to [http://localhost:3000/employers/1](http://localhost:3000/employers/1)
2. Click on Browse and upload the acme_earnings.csv file
3. Click on "Upload Earnings" button
4. Will display "Data upload was successful", if the file was uploaded successfuly. else will notice an error box with the failure reason.

## To test

1. bundle exec rspec <path>
   (Eg: bundle exec rspec ./spec/controllers/employers_controller_spec.rb)
