class EmailArticlePlugin < Noosfero::Plugin

  def self.plugin_name
    "Email Article to Community Members Plugin"
  end

  def self.plugin_description
    _("A plugin that emails an article to the members of the community")
  end

  def article_extra_toolbar_buttons(article)
    return [] if !(profile.is_admin?(current_person) || current_person.is_admin?) || !article.kind_of?(TextArticle)
    {
      :icon => 'icon-menu-mail',
      :url => { :profile => profile.identifier, :controller => 'email_article_plugin_myprofile', :action => "send_email", :id => article},
      :title => _("Send article to members")
    }
  end
end
