class SpinController < ApplicationController
  respond_to :xml
  def show 
    @reels = Bcslots::Logic::Reels.new.random_reels
    Resque.enqueue(HelloJob, @reels)
    respond_with @reels
  end
end



class HelloJob
  @queue = :hello_job
  @i = 0

  def self.perform(reels)
    puts 'hi'
    @i += 1
  end
end
