require 'rails_helper'

RSpec.describe 'Movie Results page, movies index', type: :feature do
  describe 'when a user visits the users dashboard' do
    before(:each) do
      @user = create(:user)

      visit root_path

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit user_discover_index_path(@user)
    end

    it 'They click Top Movies, see max 20 results, Title as link to details page, and vote average', :vcr do
      click_button 'Top Rated Movies'
      movie_titles = all('li.title')
      movie_vote_averages = all('li.voteAverage')

      expect(movie_titles.count).to be <= 20
      expect(movie_vote_averages.count).to be <= 20

      expect(current_path).to eq(user_movies_path(@user))
      within "#movie-238" do
        expect(page).to have_link('The Godfather')
        expect(page).to have_content('Vote Average: 8.7')
        click_link 'The Godfather'
      end

      expect(current_path).to eq("/users/#{@user.id}/movies/238") # ID is hard coded, need to think of better way to grab 
    end

    it 'They search something, see max 20 results, Title as link to details page, and vote average', :vcr do
      fill_in :query, with: 'Star Wars'
      click_button 'Search'
  
      expect(page).to have_content('Star Wars')
      movie_titles = all('li.title')
      movie_vote_averages = all('li.voteAverage')

      expect(movie_titles.count).to be <= 20
      expect(movie_vote_averages.count).to be <= 20

      expect(current_path).to eq(user_movies_path(@user))
      within "#movie-11" do # ID is hard coded, need to think of better way to grab 
        expect(page).to have_link('Star Wars')
        expect(page).to have_content('Vote Average: 8.2')
        click_link 'Star Wars'
      end

      expect(current_path).to eq("/users/#{@user.id}/movies/11") # ID is hard coded, need to think of better way to grab 
    end
  end
end
