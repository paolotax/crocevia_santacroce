# encoding: utf-8

### UTILITY METHODS ###

def create_visitor
  @visitor ||= { :name => "Testy McUserton", :email => "example@example.com",
    :password => "please", :password_confirmation => "please" }
end

def find_user
  @user ||= User.first conditions: {:email => @visitor[:email]}
end

def create_unconfirmed_user
  create_visitor
  delete_user
  sign_up
  visit '/users/sign_out'
end

def create_user
  create_visitor
  delete_user
  @user = FactoryGirl.create(:user, email: @visitor[:email])
end

def create_admin_user
  create_visitor
  delete_user
  @user = FactoryGirl.create(:user, email: @visitor[:email])
  @user.has_role :admin
end

def delete_user
  @user ||= User.first conditions: {:email => @visitor[:email]}
  @user.destroy unless @user.nil?
end

def sign_up
  delete_user
  visit '/users/sign_up'
  fill_in "user_name", :with => @visitor[:name]
  fill_in "user_email", :with => @visitor[:email]
  fill_in "user_password", :with => @visitor[:password]
  #fill_in "Password confirmation", :with => @visitor[:password_confirmation]
  click_button "Iscriviti a Crocevia"
  find_user
end

def sign_in
  visit '/users/sign_in'
  fill_in "user_email", :with => @visitor[:email]
  fill_in "user_password", :with => @visitor[:password]
  click_button "Accedi"
end

### GIVEN ###
Given /^I am not logged in$/ do
  visit '/users/sign_out'
end

Given /^I am logged in$/ do
  create_user
  sign_in
end

Given /^I exist as a user$/ do
  create_user
end

Given /^I do not exist as a user$/ do
  create_visitor
  delete_user
end

Given /^I exist as an unconfirmed user$/ do
  create_unconfirmed_user
end

Given /^I am an admin user$/ do
  @user.add_role :admin
end

### WHEN ###
When /^I sign in with valid credentials$/ do
  create_visitor
  sign_in
end

When /^I sign out$/ do
  visit '/users/sign_out'
end

When /^I sign up with valid user data$/ do
  create_visitor
  sign_up
end

When /^I sign up with an invalid email$/ do
  create_visitor
  @visitor = @visitor.merge(:email => "notanemail")
  sign_up
end

When /^I sign up without a password confirmation$/ do
  create_visitor
  @visitor = @visitor.merge(:password_confirmation => "")
  sign_up
end

When /^I sign up without a password$/ do
  create_visitor
  @visitor = @visitor.merge(:password => "")
  sign_up
end

When /^I sign up with a mismatched password confirmation$/ do
  create_visitor
  @visitor = @visitor.merge(:password_confirmation => "please123")
  sign_up
end

When /^I return to the site$/ do
  visit '/'
end

When /^I sign in with a wrong email$/ do
  @visitor = @visitor.merge(:email => "wrong@example.com")
  sign_in
end

When /^I sign in with a wrong password$/ do
  @visitor = @visitor.merge(:password => "wrongpass")
  sign_in
end

When /^I edit my account details$/ do
  click_link "il mio profilo"
  fill_in "Name", :with => "newname"
  fill_in "Current password", :with => @visitor[:password]
  click_button "Update"
end

When /^I look at the list of users$/ do
  sign_in
  visit "/users"
end

### THEN ###
Then /^I should be signed in$/ do
  page.should have_content "Esci"
  page.should_not have_content "Iscriviti!"
  page.should_not have_content "Accedi"
end

Then /^I should be signed out$/ do
  page.should have_content "Accedi"
  page.should have_content "Iscriviti!"
  page.should_not have_content "Esci"
end

Then /^I see an unconfirmed account message$/ do
  page.should have_content "You have to confirm your account before continuing."
end

Then /^I see a successful sign in message$/ do
  page.should have_content "Accesso effettuato con successo."
end

Then /^I should see a successful sign up message$/ do
  page.should have_content "Benvenut"
end

Then /^I should see an invalid email message$/ do
  page.should have_content "Indirizzo email o password non validi"
end

Then /^I should see a missing password message$/ do
  page.should have_content "Password can't be blank"
end

Then /^I should see a missing password confirmation message$/ do
  page.should have_content "Password doesn't match confirmation"
end

Then /^I should see a mismatched password message$/ do
  page.should have_content "Password doesn't match confirmation"
end

Then /^I should see a signed out message$/ do
  page.should have_content "Sei uscito correttamente."
end

Then /^I see an invalid login message$/ do
  page.should have_content "Indirizzo email o password non validi."
end

Then /^I should see an account edited message$/ do
  page.should have_content "Il tuo account è stato correttamente modificato."
end

Then /^I should see my name$/ do
  create_user
  page.should have_content @user[:name]
end
