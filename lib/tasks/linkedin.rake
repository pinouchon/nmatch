namespace :linkedin do
  task scrape_users: :environment do
    agent = Mechanize.new

    user = EUser.find_by_login 'bounth_r'
    puts "searching linkedin page for #{user.login}..."
    agent.get("http://www.bing.com/search?q=epitech+#{user.nom}+#{user.prenom}+linkedin")


    linkedin_el = agent.page.search('#b_results h2 a').select do |el|
      href = I18n.transliterate(URI.unescape(el.attr('href')))
      href.include?('linkedin.com/pub') &&
        (href.downcase.include?("#{user.nom.downcase}-#{user.prenom.downcase}")) ||
        (href.downcase.include?("#{user.prenom.downcase}-#{user.nom.downcase}"))
    end[0]

    linkedin_url = linkedin_el && linkedin_el.attr('href')
    if linkedin_url
      binding.pry
      agent.get(linkedin_url)
      # linkedin url
      linkedin_url
      # profile pic
      agent.page.search('.profile-picture img').andand.attr('src').andand.value
      # nb connections
      agent.page.search('.member-connections strong').first.text
      # profile description
      agent.page.search('.profile-overview #headline .title').text
      # locality
      agent.page.search('.profile-overview .locality').text
      # industry
      agent.page.search('.profile-overview .industry').text

      # summary
      agent.page.search('#background-summary-container .summary .description').text

      # skills
      agent.page.search('#background-skills #profile-skills .endorse-item .endorse-item-name-text').map do |el|
        el.text
      end
      binding.pry
    end

  end

end
