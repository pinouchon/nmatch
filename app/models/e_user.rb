class EUser < ActiveRecord::Base
  belongs_to :batch
  has_many :e_modules
  has_many :e_notes

  validates_presence_of :login
  validates_uniqueness_of :login, scope: :batch_id
  validates_presence_of :batch_id

  def to_hash
    {title: title,
     login: login,
     nom: nom,
     prenom: prenom,
     picture: picture,
     location: location,
     uid: uid,
     gid: gid,
     promo: promo,
     credits: credits,
     gpa_bachelor: gpa_bachelor,
     gpa_master: gpa_master,
     gpa_average: gpa_average,
     average: average,
     year: year,
     school: school
    }
  end
end
