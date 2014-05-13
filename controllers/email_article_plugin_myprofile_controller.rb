class EmailArticlePluginMyprofileController < MyProfileController

  needs_profile
#  before_filter :check_access_to_profile, :except => [:join, :join_not_logged, :index, :add]
#  before_filter :store_location, :only => [:join, :join_not_logged, :report_abuse, :send_mail]
#  before_filter :login_required, :only => [:add, :join, :join_not_logged, :leave, :unblock, :leave_scrap, :remove_scrap, :remove_activity, :view_more_activities, :view_more_network_activities, :report_abuse, :register_report, :leave_comment_on_activity, :send_mail]
  
  def send_email
    article = Article.find(params[:id])
    EmailArticlePluginMyprofileController::Sender.deliver_mail(article)
    render :text=>'ok'
  end
  
  class Sender < ActionMailer::Base
    def mail(article)
      members = article.profile.members
      emails = []
      members.each{ |m|
        emails.push(m.user.email) 
      }
      content_type 'text/html'
      recipients emails
      from "#{article.author.user.name} <#{article.author.user.email}>"
      reply_to article.author.user.email
      subject "[Artigo] " + article.title
      body article.body
    end
  end  
end

