require 'rails_helper'

RSpec.describe 'Root Page, Welcome Index', type: :feature do
  describe 'When a user visits the root path "/"' do
    before(:each) do
      @user_1 = User.create!(name: 'Sam', email: 'sam_t@email.com', password: 'elmoonfire12', password_confirmation: 'elmoonfire12')
      @user_2 = User.create!(name: 'Tommy', email: 'tommy_t@gmail.com', password:  'pegmel0715', password_confirmation:  'pegmel0715')

      visit root_path
    end

    it 'They see title of application, and link back to home page' do
      expect(page).to have_content('Viewing Party')
      expect(page).to have_link('Home')
    end

    it 'They see button to create a New User' do
      expect(page).to have_selector(:link_or_button, 'Create New User')
    end

    it 'They can see a link for "Log In", when they click on "Log In" they are taken to a Log In page /login' do
      expect(page).to have_selector(:link_or_button, 'Log In')

      click_on 'Log In'

      expect(current_path).to eq(login_path)
    end

    it 'When they are logged in, they see list of existing Users emails' do
      expect(page).to_not have_content('Existing Users')
      expect(page).to_not have_content('sam_t@email.com')
      expect(page).to_not have_content('tommy_t@gmail.com')
      expect(page).to have_selector(:link_or_button, 'Log In')
      expect(page).to have_selector(:link_or_button, 'Create New User')

      click_on 'Log In'

      expect(current_path).to eq(login_path)
      expect(page).to have_content('Email')
      expect(page).to have_content('Password')

      fill_in :email, with: @user_1.email
      fill_in :password, with: @user_1.password
      
      click_on 'Log In'

      expect(current_path).to eq(user_path(@user_1))

      click_on 'Home'

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Existing Users')
      expect(page).to have_content('sam_t@email.com')
      expect(page).to have_content('tommy_t@gmail.com')
      expect(page).to have_selector(:link_or_button, 'Log Out')
      expect(page).to_not have_selector(:link_or_button, 'Log In')
      expect(page).to_not have_selector(:link_or_button, 'Create New User')
    end

    it 'When a user is directed to the Log In page, they can input their unique email and password, and when they enter their unique email and correct password, they are taken to their dashboard page' do      
      click_on 'Log In'
      
      expect(current_path).to eq(login_path)
      
      fill_in :email, with: @user_1.email
      fill_in :password, with: @user_1.password
      
      click_on 'Log In'

      expect(current_path).to eq(user_path(@user_1))
      expect(page).to have_content("Welcome, #{@user_1.name}!")
      expect(page).to have_content("#{@user_1.name}'s Dashboard")
    end
    
    it 'When a user is directed to the Log In page, they can input their unique email and password, and fail to fill in their correct credentials, then they are taken back to the Log In page where they can see a flash message telling them that they entered incorrect credentials' do
      click_on 'Log In'
      
      expect(current_path).to eq(login_path)
      
      fill_in :email, with: @user_1.email
      fill_in :password, with: 'wrongemail123'
      
      click_on 'Log In'

      expect(current_path).to eq(login_path)
      expect(page).to have_content('Sorry, your credentials are bad.')
    end

    it 'Once a user is loged in and redirected to the landing page, they will no longer see a link to Log In or Create an account, but see a link to Log Out and once they click the link to Log out, then they are redirected to the landing page where the Log In link is now visible again' do
      expect(page).to have_selector(:link_or_button, 'Log In')
      expect(page).to have_selector(:link_or_button, 'Create New User')

      click_on 'Log In'

      expect(current_path).to eq(login_path)
      expect(page).to have_content('Email')
      expect(page).to have_content('Password')

      fill_in :email, with: @user_1.email
      fill_in :password, with: @user_1.password
      
      click_on 'Log In'

      expect(current_path).to eq(user_path(@user_1))
      expect(page).to have_content("Welcome, #{@user_1.name}")

      visit root_path

      expect(page).not_to have_selector(:link_or_button, 'Log In')
      expect(page).not_to have_selector(:link_or_button, 'Create New User')
      
      expect(page).to have_selector(:link_or_button, 'Log Out')

      click_on 'Log Out'

      expect(page).to have_content("You've been logged out!")
      expect(page).to have_selector(:link_or_button, 'Log In')
      expect(page).to have_selector(:link_or_button, 'Create New User')
    end

    it 'When a visitor visits the landing page, they should not see a list of existing users' do
      expect(page).to have_selector(:link_or_button, 'Log In')
      expect(page).to have_selector(:link_or_button, 'Create New User')
      expect(page).to_not have_content('Existing Users')
      expect(page).to_not have_link('sam_t@email.com')
      expect(page).to_not have_link('tommy_t@gmail.com')
    end

    it 'When a registered user visits the landing page, they should no longer see the list of existing users as links, but just a list of their emails' do
      click_on 'Log In'

      expect(current_path).to eq(login_path)
      expect(page).to have_content('Email')
      expect(page).to have_content('Password')

      fill_in :email, with: @user_1.email
      fill_in :password, with: @user_1.password
      
      click_on 'Log In'

      expect(current_path).to eq(user_path(@user_1))
      expect(page).to have_content("Welcome, #{@user_1.name}")

      visit root_path

      expect(page).to have_content('sam_t@email.com')
      expect(page).to have_content('tommy_t@gmail.com')
    end


    it 'When a visitor visits the landing page, and they try to visit "/dashboard", they should remain on the landing page with a flash error message' do
      visit user_path(@user_1)

      expect(current_path).to eq(root_path)
      expect(page).to have_content('You must log in to view the dashboard')
    end
  end
end
