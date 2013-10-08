require 'open-uri'
class Kt 
  #  http://www.khanacademy.org/api/v1/topictree
  BL=["root", "the", "to", "a", "and", "other", "res","partner", "content", "one", "re", "in", "", "of", "on", "our", "for" ]
  
  def data=(d)
    @data = d
    nil
  end
    
  def show(key)
    @counter = 0
    s_show(@data, key, [])
    @counter
  end
    
  def s_show(d, key,depth)
    h = (depth.map{|i| i.split("-")}.flatten+d["keywords"].to_s.split(" ").map{|i| i})
    h=h.join(",").split(",").map{|i| i.downcase.gsub("_"," ")}.uniq.reject{|i| BL.include?(i.to_s) }
    if ["Video", "Article"].include?(d["kind"])
      @counter+=1 
      puts h.join(",") + " => " + d[key].to_s
    end
    d["children"].each{|sd|
      s_show(sd, key,depth+[d["slug"]])
    } unless d["children"].nil?
    nil
  end
  
  def self.download
    k=Kt.new
    res = open("http://www.khanacademy.org/api/v1/topictree")
    r = File.open('kt.txt',"wb" )
    r.puts res.read
    r.close
    #o = ActiveSupport::JSON.decode(res.read)
    
  end
  
  def read
    r = File.open('kt.txt',"rb" )
    v = ""
    while line = r.gets
      v+=line
    end
    @data = ActiveSupport::JSON.decode(v)
  end
  
end
