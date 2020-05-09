Rails.application.routes.draw do
  mount Hyperstack::Engine => '/hyperstack'  # this route should be first in the routes file so it always matches

  # access progress web app manifest and worker
  get '/service-worker.js' => "service_worker#service_worker"
  get '/manifest.json' => "service_worker#manifest"
  get '/flag/:flag', to: 'flag#get'

  get '/(*others)', to: 'hyperstack#app'
end
