class User < ActiveRecord::Base
  has_many :tag_user
  has_many :tags, through: :tag_user
  belongs_to :special_user, polymorphic: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def to_hash
    {
      id: id,
      user_type: user_type,
      school: school,
      first_name: first_name,
      last_name: last_name,
      picture: picture,
      city: city,
      year: year,
      credits: credits,
      real_average: real_average,
      real_gpa: real_gpa,
      average: average,
      gpa: gpa,
      linkedin_url: linkedin_url,
      linkedin_picture: linkedin_picture,
      linkedin_connections: linkedin_connections,
      linkedin_description: linkedin_description,
      linkedin_locality: linkedin_locality,
      linkedin_industry: linkedin_industry,
      linkedin_summary: linkedin_summary,
      linkedin_scraped: linkedin_scraped
    }
  end
end
