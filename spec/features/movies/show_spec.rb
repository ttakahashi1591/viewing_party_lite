require 'rails_helper'

RSpec.describe 'Movie Details Page', type: :feature do
  describe 'when a user visits a movies details page' do
    before(:each) do
      @user = create(:user)

      visit root_path

      click_on 'Log In'

      expect(current_path).to eq(login_path)
      expect(page).to have_content('Email')
      expect(page).to have_content('Password')

      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      
      click_on 'Log In'
     
      visit "users/#{@user.id}/movies/238"
    end

    it 'displays a button to create a button to create a viewing party', :vcr do
      expect(page).to have_button('Create A Party')
    end

    it 'displays a button to return to the discover page', :vcr do
      expect(page).to have_button('Discover Page')
    end

    it 'displays details about the movie', :vcr do
      expect(page).to have_content('The Godfather')
      expect(page).to have_content('Average Rating: 8.7')
      expect(page).to have_content('Runtime: 2:55')
      expect(page).to have_content('Genre(s): Drama, Crime')
      expect(page).to have_content('Summary: Spanning the years 1945 to 1955')
      expect(page).to have_content('Don Vito Corleone Played by: Marlon Brando')
      expect(page).to have_content('Total Reviews: 5')
      expect(page).to have_content('Author: futuretv')
      expect(page).to have_content('Content: Great Movie **Ever**')
    end

    it 'When a visitor visits the movies show page, and they click the button to create a viewing party, they should be redirected to the movies show page with a flash error message', :vcr do
      user = create(:user)
      
      visit "users/#{user.id}/movies/238"

      click_on 'Create A Party'

      expect(current_path).to eq("/users/#{user.id}/movies/238")
      expect(page).to have_content('You must be logged in or registered to create a party')
    end
  end
end