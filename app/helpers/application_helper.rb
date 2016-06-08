module ApplicationHelper
  def flash_messages
    [flash[:alert], flash[:notice], flash[:success]].flatten.reject(&:blank?)
  end
end
