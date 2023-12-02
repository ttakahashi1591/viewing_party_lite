class Party < ApplicationRecord
  validates :movie_id, presence: true, numericality: true

  has_many :user_parties
  has_many :users, through: :user_parties

  def date_and_time
    parsed_date = Date.parse(self.date)
    formatted_date = parsed_date.strftime("%B%e, %Y")
    "#{formatted_date} #{self.start_time}"  
  end

  def host?(user)
    host = UserParty.find_by_sql(
    "select user_parties.host from user_parties
    inner join parties on user_parties.party_id = parties.id
    where parties.id = #{self.id}
    and user_parties.user_id = #{user.id};"
    ).first.host

    return "Hosting" if host
    return "Invited" if !host
  end

  def attendees
    Party.find_by_sql(
      "select users.name from users
      inner join user_parties on user_parties.user_id = users.id
      inner join parties on user_parties.party_id = parties.id
      where parties.id = #{self.id}
      and user_parties.host = false"
    )
  end
end
