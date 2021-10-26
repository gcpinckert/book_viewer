require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do
  @title = "The Adventures of Sherlock Holmes"
  @chapters = IO.readlines("data/toc.txt")
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map { |paragraph| "<p>#{paragraph}</p>" }.join
  end

  def search_chapters(search_terms)
    (1..@chapters.size).each_with_object({}) do |num, hash|
      text = File.read("data/chp#{num}.txt")
      hash[num] = @chapters[num - 1] if text.include?(search_terms)
    end
  end
end

get "/" do
  erb :home
end

get "/chapters/:number" do
  number = params[:number].to_i

  redirect "/" unless (1..@chapters.size).cover? number

  @chapter_title = "Chapter #{number} : #{@chapters[number - 1]}"
  @chapter_text = File.read("data/chp#{params[:number]}.txt")

  erb :chapter
end

get "/search" do
  @matches = search_chapters(params[:query]) if params[:query]
  erb :search
end

not_found do
  redirect "/"
end