class CasenotesController < ActionController::Base
  layout "application"


  def new
    @casenote = Casenote.new
  end
end