# Configure your routes here
# See: https://guides.hanamirb.org/routing/overview
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }

#
get '/leaderboard', to: 'leaderboard#index'

#
get '/players/new', to: 'players#new'
post '/players', to: 'players#create'

get '/players/:id', to: 'players#show'

#
get '/tournaments/new', to: 'tournaments#new'
post '/tournaments', to: 'tournaments#create'

get '/tournaments/:id', to: 'tournaments#show'
