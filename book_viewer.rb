require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @chapters = IO.readlines("data/toc.txt")
  erb :home
end

get "/chapters/1" do
  @chapter_text = File.read("data/chp1.txt").split("/n/n")
  @chapters = IO.readlines("data/toc.txt")
  erb :chapter
end
