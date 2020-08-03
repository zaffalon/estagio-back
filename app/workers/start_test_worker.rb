class StartTestWorker
  include Sidekiq::Worker

  def perform(user_id)

    user = User.find(user_id)

    begin
      if user.started_test.nil?
        user.started_test = StartedTest.new(:started_at => DateTime.current, :finish_until => DateTime.current + 10.days)
        user.save
      end
    rescue
      raise
    end
  end
end