class HomeController < ApplicationController
  def index
    render html: "<h1>drew-server API</h1><p>This is the drew-server API. Maybe docs will go here later. Who knows?</p>".html_safe
  end
end
