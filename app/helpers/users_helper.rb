module UsersHelper
  def user_form_button
    case params[:action]
    when 'new'
      'SignUp'
    when 'edit'
      'Update'
    when 'create'
      'SignUp'
    when 'update'
      'Update'
    else
      raise 'unexpected action'
    end
  end
end
