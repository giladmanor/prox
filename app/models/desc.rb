require 'open-uri'
class Desc 
  
  
  def self.eat
    f = File.open('long_abstracts_en.nt',"rb" )
    v = ""
    i=0
    last_key = Fatlink.last.key
    started = false
    while (line = f.gets)
      i+=1
      d = line.split("<http://dbpedia.org/ontology/abstract>")
      key = d[0].split("/").last.gsub(">","").gsub("_"," ").strip.downcase
      
      if started || key==last_key
        desc = d[1].split("\"@en")[0].gsub(" \"","").strip unless d[1].nil?
        Fatlink.create({:key=>key, :data=>desc})
        started=true
      end
      
      puts i#"[#{key}] || [#{desc}]"
      
    end
    f.close
  end
  
end
