namespace :epitech do
  BASE_URL = 'https://intra.epitech.eu'

  def find_module(modules, note, user, batch_id)
    filtered_modules = modules.select { |m|
      m.e_user_id == user.id &&
        m.batch_id == batch_id &&
        m.codemodule == note.codemodule &&
        m.scolaryear == note.scolaryear &&
        m.codeinstance == note.codeinstance
    }
    return filtered_modules[0] if filtered_modules.count == 1
    filtered_modules = modules.select { |m|
      m.e_user_id == user.id &&
        m.batch_id == batch_id &&
        m.codemodule == note.codemodule &&
        m.scolaryear == note.scolaryear
    }
    return filtered_modules[0] if filtered_modules.count == 1
    filtered_modules = modules.select { |m|
      m.e_user_id == user.id &&
        m.batch_id == batch_id &&
        m.codemodule == note.codemodule
    }
    return filtered_modules[0] if filtered_modules.count == 1
    filtered_modules = EModule.where({codemodule: note.codemodule, scolaryear: note.scolaryear, codeinstance: note.codeinstance})
    return filtered_modules[0] if filtered_modules.andand.count == 1
    filtered_module = EModule.where({codemodule: note.codemodule}).first
    return filtered_module if filtered_module
    puts "Cannot find module"
    filtered_modules[0]
  end

  def login
    agent = Mechanize.new
    begin
      agent.get(BASE_URL)
    rescue Mechanize::ResponseCodeError => e
      raise 'Too many forms' if e.page.forms.count != 1
      form = e.page.forms.first
      form.login = ENV['EPITECH_LOGIN']
      form.password = ENV['EPITECH_UNIX_PASSWORD']
      form.submit
    end
    return agent
  end

  def scape_user(agent, batch_id, user)
    puts "Get #{BASE_URL}/user/#{user.login}"
    ################################################################# Parsing page
    1.upto 10 do
      begin
        agent.get("#{BASE_URL}/user/#{user.login}", {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE})
        break
      rescue Net::HTTP::Persistent::Error, OpenSSL::SSL::SSLError => e
        puts "Exception: #{e.message}. Sleeping 20 sec"
        sleep 20
        abort('aborting.')
        next
      end
    end
    js = agent.page.search('script[type="text/javascript"]').
      select { |e| e.text.include?('var user = user || {};') }[0].
      text rescue nil
    first = Regexp.quote('window.user = $.extend(window.user || {}, {')
    last = Regexp.quote('});    //-->')
    json = '{' + js[/#{first}(.*)#{last}/m, 1] + '}'
    hash = ExecJS.eval(json)

    ################################################################# Modules and notes insertion
    EModule.where(batch_id: batch_id).where(e_user_id: user.id).delete_all
    modules = Array(EModule.create(hash['modules']) do |m|
      m.e_user_id = user.id
      m.batch_id = batch_id
    end)
    puts "#{modules.count}/#{hash['modules'].count} modules inserted"

    ENote.where(batch_id: batch_id).where(e_user_id: user.id).delete_all
    notes = ENote.create(hash['notes']) do |m|
      m.e_user_id = user.id
      m.batch_id = batch_id
    end
    puts "#{notes.count}/#{hash['notes'].count} notes inserted. Setting module_ids..."
    notes.each do |n|
      n.e_module_id = find_module(modules, n, user, batch_id).andand.id
      n.save
    end
    puts 'Done'

    ################################################################# Other fields (credits, gpa)
    user.credits = agent.page.search('label:contains("Total credits acquired")+span').text
    gpa1 = agent.page.search('label:contains("G.P.A.")+span').text
    gpa2 = agent.page.search('label:contains("G.P.A.")+span+span').text
    if gpa1.match(/^[\.0-9]+$/)
      user.gpa_average = gpa1.to_f
    end
    if (gpa_bachelor = gpa1[/achelor : ([\.0-9]+)/, 1])
      user.gpa_bachelor = gpa_bachelor.to_f
    end
    if (gpa_master = gpa2[/aster : ([\.0-9]+)/, 1])
      user.gpa_master = gpa_master.to_f
    end
    if user.gpa_bachelor || user.gpa_master
      values = [user.gpa_bachelor, user.gpa_master].compact
      user.gpa_average = values.reduce(:+).to_f / values.size
    end
    user.promo = agent.page.search('.course .promo').text[/Year (\d+)/i, 1]
    user.school = agent.page.search('.course .school').text.strip
    user.uid = agent.page.search('.value.uid').text.strip
    user.gid = agent.page.search('.value.gid').text.strip
    user.year = agent.page.search('.item .studentyear').text.strip
    user.city = agent.page.search('.item.city .value').text[/(\w+)$/, 1]
    user.last_batch = batch_id

    user.save
    user.average = user.calculate_average
    user.save

    ap user.to_hash
  end

  task remove_users: :environment do
    batch_id = Batch.current_or_create.id
    puts "#{EUser.where(batch_id: batch_id).count} EUser in db"
    EUser.delete_all
    puts "#{EUser.where(batch_id: batch_id).count} EUser in db"
  end

  task load_users: :environment do
    batch_id = Batch.current_or_create.id
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

  task scrape_users: :environment do
    puts 'Scraping users...'
    batch_id = Batch.current_or_create.id
    puts 'Login in...'
    agent = login
    puts 'Logged in.'
    EUser.where("last_batch < #{batch_id}").each do |user|
      scape_user(agent, batch_id, user)
    end
  end

end
