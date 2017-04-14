class ConfigController < ApplicationController
  before_action :authenticate_admin!
end
