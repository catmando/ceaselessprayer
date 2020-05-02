class ServiceWorkerController < ApplicationController
  protect_from_forgery except: :service_worker

  def service_worker
    # render :body => nil, :status => 404 # until we get an update mechanism to work everything else ready to go and tested
  end

  def manifest
  end
end
