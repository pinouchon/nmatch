class SearchController < ApplicationController
  def index
    @students = Student.
      includes(:tags).
      where(linkedin_scraped: true).
      order('real_average DESC').
      all
  end
end
