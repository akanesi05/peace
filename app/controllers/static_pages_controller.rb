class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: %i[puraibasi]
  def puraibasi; end
end
