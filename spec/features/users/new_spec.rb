require 'rails_helper'

RSpec.describe 'new user', type: :feature do
  describe 'When user visits "/register"' do
    before(:each) do
      @user_1 = User.create!(name: 'Sam', email: 'sam_t@email.com')

      visit register_user_path
    end

    it 'They see a Home link that redirects to landing page' do
      expect(page).to have_link('Home')
      click_link "Home"
      expect(current_path).to eq(landing_path)
    end

    it 'They see a form that includes Name, Email, and Create New User button' do
      expect(page).to have_field('Name')
      expect(page).to have_field('Email')
      expect(page).to have_selector(:link_or_button, 'Create New User')    
    end

    it 'They fill in form with information, email (unique), submit, redirects to user show page' do
      fill_in 'Name', with: "Sammy"
      fill_in 'Email', with: "sammy@email.com"
      click_button 'Create New User'

      new_user = User.last
save_and_open_page
      expect(page).to have_content('Successfully Added New User')
      expect(current_path).to eq(user_path(new_user))
    end

  end

end