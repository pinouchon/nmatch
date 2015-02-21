namespace :epitech do
  def get_batch_id
    batch_id = ENV['BATCH_ID'] || Batch.last.id
    batch_id = Batch.create({active: true}).id if !batch_id
    batch_id
  end

  task remove_users: :environment do
    batch_id = get_batch_id
    puts "#{EUser.where(batch_id: batch_id).count} EUser in db"
    EUser.delete_all
    puts "#{EUser.where(batch_id: batch_id).count} EUser in db"
  end

  desc "TODO"
  task load_users: :environment do
    batch_id = get_batch_id
    puts "#{EUser.where(batch_id: batch_id).count} EUser in db"

    puts 'Loading file...'
    file = File.open("db/e_users.json", "r")
    json = Oj.load(file.read)
    puts 'Inserting users...'
    EUser.create(json['items']) do |u|
      u.batch_id = batch_id
    end
    puts "#{EUser.where(batch_id: batch_id).count} EUser in db"
    puts 'Done.'
  end

end
