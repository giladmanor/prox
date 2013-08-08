class ApiController < ApplicationController
  
  def q
    key = params[:id]
    api = params[:api] || "web"
    res = Slot.where("key = ? and api=?", key,api).first
    if res.nil?
      data = case api
      when "img"
        img(key)
      when "vid"
        video(key)
      when "web"
        web(key)
      end
      res = Slot.create({:key=>key, :api=>api, :data=>data.to_json})
    end
    render :text=>res.data
  end
  
  
  private
  
  
  def video(word)
    GoogleAjax.referrer = "wikibrains.com"
    response = GoogleAjax::Search.video(word)
    response[:results].map{|r| 
      src = "http://www.youtube.com/embed/#{r[:play_url].split('/v/')[1].split('&')[0]}" unless r[:play_url].nil?
      {
        :name=>"youtube",
        :title=>r[:title_no_formatting],
        :host=>r[:publisher],
        :thumbnail=>r[:tb_url],
        :src=>src,
        :info=>r[:content],
        :user_image=> "google.png"
    }}
  end
  
  def img(word)
    GoogleAjax.referrer = "wikibrains.com"
    response = GoogleAjax::Search.images(word)
    response[:results].map{|r|{
      :name=>"gimage",
      :title=>r[:title_no_formatting],
      :info=>r[:content_no_formatting],
      :thumbnail=>r[:tb_url],
      :src=>r[:url],
      :user_image=> "google.png"
    }}
  end
  
  def web(word)
    GoogleAjax.referrer = "wikibrains.com"
    
    response = GoogleAjax::Search.web(word)
    response[:results].map{|i| {
      :name=>"google",
      :title=> i[:title_no_formatting].gsub("'","`"),
      :info=>i[:content].gsub("'","`"),
      :host=> i[:visible_url].gsub("'","`"),
      :link=>  i[:unescaped_url],
      :user_image=> "google.png"
    }}
  end
  
  
  
end
