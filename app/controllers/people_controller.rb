class PeopleController < ApplicationController

  def index
    @people = client.suggested_people(['ru'])
    @featured_people = @people['featured'].map { |user| PeriscopeUser.new(user) }
    @popular_people = @people['popular'].map { |user| PeriscopeUser.new(user) }
  end
end
