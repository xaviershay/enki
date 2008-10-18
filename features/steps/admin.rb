Given /I am logged in/ do
  post '/admin/session', :bypass_login => '1'
end

Then /a RuntimeError is thrown when I press "(.*)"/ do |button|
  lambda {
    clicks_button(button)
  }.should raise_error
end
