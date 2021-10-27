require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"

before do
  @title = "The Adventures of Sherlock Holmes"
  @chapters = IO.readlines("data/toc.txt")
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map.with_index do |paragraph, index| 
      "<p id='#{index}'>#{paragraph}</p>"
    end
  end

  def search_chapters(search_terms)
    (1..@chapters.size).each_with_object({}) do |num, hash|
      text = File.read("data/chp#{num}.txt")
      title = @chapters[num - 1]
      if text.include?(search_terms)
        hash[title] = { num: num, paragraphs: search_paragraphs(search_terms, text) }
      end
    end
  end

  def search_paragraphs(search_terms, text)
    paragraphs = {}
    text.split("\n\n").each_with_index do |paragraph, index|
      if paragraph.include?(search_terms)
        paragraphs[index] = paragraph
      end
    end

    paragraphs
  end

  def bold_search_terms(search_terms, text)
    text.gsub(search_terms, "<b>#{search_terms}</b>")
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