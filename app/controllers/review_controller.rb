class ReviewController < ApplicationController

  def property_reviews
    airline = Airline.find_by(english_name: params[:property_name])
    not_found if airline.nil?

    @airline_name = airline.persian_name
    @airline_code = airline.code
    @page = airline.english_name
    @rate_count = airline.rate_count
    @rate_average = airline.rate_average

    @rate_count ||= 0
    @rate_average ||= 0

    @reviews = Review.where(page: @page).where.not(text:"")
    
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def register
    author = params[:author]
    rate = params[:rate]
    text = params[:text]
    page = params[:page]

    review = Review.create(author:author,text:text,page:page,rate:rate)
    TelegramMonitoringWorker.perform_async("📣 #{page}, #{author}, #{text}, #{rate}")          
    @message = review.nil? ? "ببخشید خطایی رخ داد. لطفا دوباره آدرس را وارد کنید." : "نظرتان ثبت شد. اگر نظری نوشته‌اید، برای دیدن پیغام‌تان صفحه را رفرش کنید. ممنونیم :‌)"

    respond_to do |format|
      format.js 
      format.html
    end
  end
  
end
