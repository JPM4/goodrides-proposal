module Api
  class RidesController < ApiController
    def show
      @ride = Ride.includes(:wants).find(params[:id])
      @wants_hash = {}
      if signed_in?
        @wants_hash[@ride.id] = @ride.wants.find_by(user_id: current_user.id)
      end
      @reviewed = { reviewed: user_reviewed? }
      @user_rating = user_rating
      @tweets = twitter_client
      render :show
    end

    def index
      if params[:query]
        @rides = search_results
      elsif params[:highest] == "true"
        @rides = highest_rated
      elsif params[:rated] == "true"
        @rides = user_reviewed(true)
      elsif params[:not_rated] == "true"
        @rides = user_reviewed(false)
      elsif params[:most_wanted]
        @rides = most_wanted
      elsif params[:user_wants]
        @rides = user_wants
      else
        @rides = Ride.includes(:wants)
      end

      if signed_in?
        @wants_hash = current_user.rides_wants_hash
      else
        @wants_hash = {}
      end

      render :index
    end

    private

    def user_reviewed(boolean)
      reviewed = []
      not_reviewed = []
      Ride.all.each do |ride|
        if current_user.reviews.exists?(ride_id: ride.id)
          reviewed << ride
        else
          not_reviewed << ride
        end
      end

      boolean ? reviewed : not_reviewed
    end

    def highest_rated(top = 4)
      sorted = Ride.all.sort_by { |ride| ride.average_rating }
      sorted.last(top)
    end

    def user_reviewed?
      current_user.reviews.exists?(ride_id: params[:id])
    end

    def search_results
      query = params[:query].downcase.tr('.', '')
      Ride.all.where("LOWER(REPLACE(rides.name, '.', '')) LIKE LOWER(?)", "%#{query}%")
    end

    def most_wanted(top = 4)
      sorted = Ride.all.sort_by { |ride| ride.wants.size }
      sorted.last(top)
    end

    def user_wants
      current_user.wanted_rides
    end

    def user_rating
      review = current_user.reviews.find_by_ride_id(params[:id])
      if user_reviewed?
        @user_rating = { user_rating: review.star_rating }
      else
        @user_rating = { user_rating: nil }
      end
    end

    def twitter_client
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
        config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
        config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
        config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
      end

      tweets = client.search(@ride.name, result_type: "recent").take(3).collect do |tweet|
        "#{tweet.user.screen_name}: #{tweet.text}"
      end

      tweets
    end
  end
end
