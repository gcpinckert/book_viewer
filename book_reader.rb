require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @chapters = IO.readlines("data/toc.txt")
  erb :home
end

get "/chapters/:number" do
  @title = "The Adventures of Sherlock Holmes"
  @chapters = IO.readlines("data/toc.txt")
  number = params[:number].to_i
  @chapter_title = "Chapter #{number} : #{@chapters[number - 1]}"
  @chapter_text = File.read("data/chp#{params[:number]}.txt").split("\n\n")
  erb :chapter
end