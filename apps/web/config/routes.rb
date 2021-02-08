# Configure your routes here
# See: https://guides.hanamirb.org/routing/overview
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
get '/leaderboard', to: 'leaderboard#index'
get '/players/new', to: 'players#new'
post '/players', to: 'players#create'
get '/tournaments/new', to: 'tournaments#new'
post '/tournaments', to: 'tournaments#create'
