require 'sinatra'
require 'json'
require 'open-uri'
require 'uri'
require 'nokogiri'
require 'date'

# レシピ検索
class RecipeSearch
  # 初期化
  def initialize(searchword)
    @searchword = searchword
  end

  # レシピ検索(アイテム解説付き)
  def recipe_search
    array = []
    # スクレイピングしてくるURL
    url = "https://www26.atwiki.jp/minecraft/pages/1073.html"
    items = nil
    # アイテム画像URLにタイムスタンプを付与するため
    timestamp = Time.now.to_i

    # parse only first time and keep items
    if !items
      doc = Nokogiri::HTML.parse(open(url),nil,"utf-8")
      items = doc.xpath("//tr").select{|tr|
        tr.children.filter('td').length == 3
      }.map{|tr|
        item = tr.children.filter('td')
        {
          name: item[0].text,
          image: item[1].xpath('.//img').map{|img| "http:#{img.attribute('src')}##{timestamp}"}.join("\n"),
          craft: item[2].text
        }
      }
    end

    items.each do |x|
      if x[:name].downcase! =~ /#{@searchword}/
        array.push("#{x[:name]}\n#{x[:craft]}\n#{x[:image]}\n")
      end
    end

    array.push("Not Found") if array == []

    return array

  end

  # レシピ検索(レシピ画像のみ)
  def image_search
  end

end
