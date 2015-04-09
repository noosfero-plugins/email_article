
class EmailArticlePluginMyprofileController < MyProfileController

  needs_profile

  def send_email
    unless profile.is_admin?(user) || user.is_admin?
      render :status => :forbidden, :text => "Forbidden user"
      return
    end
    mailing_params = {"subject"=>"assunto", "body"=>"corpo"}
    @mailing = profile.mailings.build(mailing_params)
    # if request.post?
      @mailing.locale = locale
      @mailing.person = user
      if @mailing.save
        render :text => "Email sent to queue"
        #session[:notice] = _('The e-mails are being sent')
        # redirect_to_previous_location
      else
        render :status => :forbidden, :text => "Forbidden user"
        # session[:notice] = _('Could not create the e-mail')
      end
    # end
  end

end
