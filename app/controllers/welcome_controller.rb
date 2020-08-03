class WelcomeController < ApplicationController
  before_filter :require_user_session

  def index
    @finish_date = @current_user.started_test.finish_until if !@current_user.started_test.nil?
  end

  def start_test
    if @current_user.started_test.nil?
      @current_user.started_test = StartedTest.new(:started_at => DateTime.current,:finish_until => DateTime.current + 10.days)
      if @current_user.save
        redirect_to action: 'index'
      end
    else
        redirect_to action: 'index'
    end
  end

end
