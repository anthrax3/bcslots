class SpinController < ApplicationController
  respond_to :xml
  def show 
    @reels = Reel.random_reels
    Resque.enqueue(HelloJob, @reels)
    respond_with @reels
  end
end



class HelloJob
  @queue = :hello_job
  @i = 0

  def self.perform(reels)
    puts @i
    @i += 1
  end
end
