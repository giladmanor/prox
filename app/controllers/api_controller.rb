require 'open-uri'
class ApiController < ApplicationController
  
  def q
    key = params[:id]
    api = params[:api] || "web"
    res = Slot.where("key = ? and api=?", key,api).first
    if res.nil?
      data = case api
      when "img"
        img(key)#flicker(key).take(10)+
      when "vid"
        video(key)
      when "web"
        web(key)
      end
      res = Slot.create({:key=>key, :api=>api, :data=>data.to_json})
    end
    render :text=>res.data
  end
  
  def d
    key = params[:id].downcase
    word = params[:word].downcase
    
    render :json => {:res=> (find_connection(key, word) || find_connection(word, key))}
    
         
  end
  
  
  
  private
  
  def find_connection(key, word)
    res = Fatlink.find_by_key(key)
    return nil if res.nil?
    l = res.data.index(word)
    return nil if l.nil? || l<0
    pre_index = res.data[0..l].reverse.index(".")
    post_index = res.data[l..res.data.length].index(".")
    res.data.slice(l-pre_index +2,pre_index+post_index)
  end
  
  
  
  #Flicker
  #http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=c5647de58e6114f10c468d12ca718507&text=boat&format=rest
  #http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
  #key  b8770b0eb0ab05aa8d1d82e1c7b5a704
  #secret a1edc2c552820429
  
  def flicker(word)
    text = URI::encode(word)
    api_key = "b8770b0eb0ab05aa8d1d82e1c7b5a704"
    res = open("http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=#{api_key}&text=#{text}&format=json")
    jsn = res.read
    jsn = jsn[14..jsn.length-2]
    keys = ["page", "pages", "perpage", "total", "photo"]
    photos = ActiveSupport::JSON.decode(jsn)["photos"]["photo"]
    photos.map{|p|
        {
        :name=>"gimage",
        :title=>p["title"],
        :info=>"",
        :thumbnail=>"http://farm#{p["farm"]}.staticflickr.com/#{p["server"]}/#{p["id"]}_#{p["secret"]}_m.jpg",
        :src=>      "http://farm#{p["farm"]}.staticflickr.com/#{p["server"]}/#{p["id"]}_#{p["secret"]}_b.jpg",
        :user_image=> "flicker.png"
        }
      }
  end
  
  
  
  
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
