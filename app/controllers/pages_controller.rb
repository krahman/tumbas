class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]
  def home
  end

  def dashboard
  	@books = current_user.books
  end
end
