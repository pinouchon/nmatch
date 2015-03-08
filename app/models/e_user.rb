class EUser < ActiveRecord::Base
  belongs_to :batch
  has_many :e_modules
  has_many :e_notes
  has_one :student, as: :x_user

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
     school: school,
     city: city
    }
  end

  def calculate_average
    hash = EUser.includes(e_modules: :e_notes).find(id).e_modules.flat_map do |m|
      m.e_notes.map do |n|
        note = n.final_note.to_f > 42 ? 20 * (n.final_note.to_f/990) : n.final_note.to_f
        note = 42 if note > 42
        {
          weight: m.credits || 0,
          value: [0, note || 0].max
        }
      end
    end
    hash.map { |e| e[:value] * e[:weight] }.reduce(:+).to_f /
      hash.map { |e| e[:weight] }.reduce(:+).to_f
  end
end
