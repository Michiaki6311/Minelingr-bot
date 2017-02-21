require 'sinatra'
require 'json'
require './recipe_search.rb'

post '/search' do

  mr_searchword = nil
  j = JSON.parse(request.body.read)
  j['events'].select{|e| e['message']}.map{|e|
    if e['message']['text'] =~ /^!mr/ then
      mr_searchword = e['message']['text'].gsub(/^!mr\s/,'')
    end
  }

  if mr_searchword.nil? == false
    item = RecipeSearch.new(mr_searchword)
    item_details = item.recipe_search
    return item_details
  end


end
