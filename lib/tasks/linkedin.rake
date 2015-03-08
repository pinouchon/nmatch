namespace :linkedin do
  def scrape_student(agent, student)
    return if student.first_name.nil? || student.last_name.nil?
    puts "searching linkedin page for #{student.full_name}..."
    agent.get("http://www.bing.com/search?q=#{student.first_name}+#{student.last_name}+epitech+linkedin")


    linkedin_el = agent.page.search('#b_results h2 a').select do |el|
      href = I18n.transliterate(URI.unescape(el.attr('href')))
      old_cond = (href.include?('linkedin.com/pub') || href.include?('linkedin.com/in')) &&
        (href.downcase.include?("#{student.last_name.downcase}-#{student.first_name.downcase}") ||
          href.downcase.include?("#{student.first_name.downcase}-#{student.last_name.downcase}") ||
          href.downcase.include?("#{student.first_name.downcase}#{student.last_name.downcase}") ||
          href.downcase.include?("#{student.last_name.downcase}#{student.first_name.downcase}"))
      href2 = href.gsub('-', '')
      first = student.first_name.gsub(/\W/, '')
      last = student.last_name.gsub(/\W/, '')
      new_cond = href2[/linkedin\.(com|fr)\/(pub|in)\/[a-z]{0,12}#{last}#{first}/i, 0] ||
        href2[/linkedin\.(com|fr)\/(pub|in)\/[a-z]{0,12}#{first}#{last}/i, 0]
      # binding.pry if old_cond && !new_cond
      # binding.pry if !old_cond && new_cond
      new_cond
    end[0]

    linkedin_url = linkedin_el && linkedin_el.attr('href')
    if linkedin_url
      puts "Found. Getting #{linkedin_url}..."
      begin
        agent.get(linkedin_url)
        puts 'Parsing...'
        student.linkedin_url = linkedin_url
        student.linkedin_picture = agent.page.search('.profile-picture img').andand.attr('src').andand.value
        student.linkedin_connections = agent.page.search('.member-connections strong').first.text
        student.linkedin_description = agent.page.search('.profile-overview #headline .title').text
        student.linkedin_locality = agent.page.search('.profile-overview .locality').text
        student.linkedin_industry = agent.page.search('.profile-overview .industry').text
        student.linkedin_summary = agent.page.search('#background-summary-container .summary .description').text
        student.linkedin_found = true

        # skills
        agent.page.search('#background-skills #profile-skills .endorse-item .endorse-item-name-text').each do |el|
          student.tags << Tag.where(name: el.text).first_or_create
        end
        puts 'Saving:'
        ap student.to_hash
        ap student.tags.map { |t| "[#{t.name}]" }.join(' ')

      rescue Mechanize::ResponseCodeError => e
        puts "Cannot get page: #{e.message}"
      end
    else
      puts 'Not found'
    end
    student.linkedin_scraped = true
    student.save
  end

  task scrape_students: :environment do
    agent = Mechanize.new

    Student.where(linkedin_scraped: false).each do |student|
      scrape_student(agent, student)
    end


  end

end
