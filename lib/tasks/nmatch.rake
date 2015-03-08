namespace :nmatch do
  task copy_users: :environment do
    batch_id = Batch.current_or_create.id
    puts 'Deleting users of type EUser...'
    Student.where("batch_id = ? AND user_type = 'EUser'", batch_id).delete_all
    puts 'Copying e_users...'
    # e_user_hash = EUser.where('batch_id = ?', batch_id).map do |e_user|
    e_user_hash = EUser.where('last_batch = ?', batch_id).map do |e_user|
      {
        user_id: e_user.id,
        user_type: 'EUser',
        first_name: e_user.prenom,
        last_name: e_user.nom,
        picture: e_user.picture,
        city: e_user.city,
        year: e_user.promo ? 2020 - e_user.promo.to_i : nil,
        credits: e_user.credits,
        real_average: e_user.average,
        real_gpa: e_user.gpa_average,
        average: nil,
        gpa: nil
      }
    end
    puts 'Inserting users...'
    students = Student.create(e_user_hash) do |u|
      u.batch_id = batch_id
    end
    puts "#{students.count} EUsers copied"
    puts 'Done'
  end

end
