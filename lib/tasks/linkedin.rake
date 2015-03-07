namespace :linkedin do
  def scrape_user(agent, user)
    return if user.first_name.nil? || user.last_name.nil?
    puts "searching linkedin page for #{user.full_name}..."
    agent.get("http://www.bing.com/search?q=#{user.first_name}+#{user.last_name}+epitech+linkedin")


    linkedin_el = agent.page.search('#b_results h2 a').select do |el|
      href = I18n.transliterate(URI.unescape(el.attr('href')))
      old_cond = (href.include?('linkedin.com/pub') || href.include?('linkedin.com/in')) &&
        (href.downcase.include?("#{user.last_name.downcase}-#{user.first_name.downcase}") ||
          href.downcase.include?("#{user.first_name.downcase}-#{user.last_name.downcase}") ||
          href.downcase.include?("#{user.first_name.downcase}#{user.last_name.downcase}") ||
          href.downcase.include?("#{user.last_name.downcase}#{user.first_name.downcase}"))
      href2 = href.gsub('-', '')
      first = user.first_name.gsub(/\W/, '')
      last = user.last_name.gsub(/\W/, '')
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
        user.linkedin_url = linkedin_url
        user.linkedin_picture = agent.page.search('.profile-picture img').andand.attr('src').andand.value
        user.linkedin_connections = agent.page.search('.member-connections strong').first.text
        user.linkedin_description = agent.page.search('.profile-overview #headline .title').text
        user.linkedin_locality = agent.page.search('.profile-overview .locality').text
        user.linkedin_industry = agent.page.search('.profile-overview .industry').text
        user.linkedin_summary = agent.page.search('#background-summary-container .summary .description').text
        user.linkedin_found = true

        # skills
        agent.page.search('#background-skills #profile-skills .endorse-item .endorse-item-name-text').each do |el|
          user.tags << Tag.where(name: el.text).first_or_create
        end
        puts 'Saving:'
        ap user.to_hash
        ap user.tags.map { |t| "[#{t.name}]" }.join(' ')

      rescue Mechanize::ResponseCodeError => e
        puts "Cannot get page: #{e.message}"
      end
    else
      puts 'Not found'
    end
    user.linkedin_scraped = true
    user.save
  end

  task scrape_users: :environment do
    agent = Mechanize.new

    User.where(linkedin_scraped: false).each do |user|
      scrape_user(agent, user)
    end


  end

end
