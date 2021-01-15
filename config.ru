require './config/environment'
require 'warning'
Gem.path.each do |path|
  Warning.ignore(//, path)
end

run Hanami.app
