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


class NewAddressJob
  @queue = :new_address

  @retry_limit = -1

  def self.perform
    c = Curl.get("https://blockchain.info/api/receive?method=create&address=13wpvosrDc25KDbBGmj3sFA5EaoGzVi8hw&anonymous=false&callback=")
  end
end
