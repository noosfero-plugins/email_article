require File.dirname(__FILE__) + '/../test_helper'

class EmailArticlePluginTest < ActiveSupport::TestCase

  def setup
    @environment = Environment.default
    @user = create_user('testuser').person
    @profile = fast_create(Organization)
    context = mock()
    context.stubs(:current_person).returns(@user)
    context.stubs(:profile).returns(@profile)
    @plugin = EmailArticlePlugin.new(context)
  end

  attr_accessor :plugin, :profile, :user, :environment

  should 'be a noosfero plugin' do
    assert_kind_of Noosfero::Plugin, @plugin
  end

  should 'have name' do
    assert_equal 'Email Article to Community Members Plugin', EmailArticlePlugin.plugin_name
  end

  should 'have description' do
    assert_equal  _("A plugin that emails an article to the members of the community"), EmailArticlePlugin.plugin_description
  end

  should 'display button to send email for all members of a community if the user is a community admin' do
    profile.add_admin(user)
    article = fast_create(TextArticle, :profile_id => profile.id)
    assert_not_equal [], plugin.article_extra_toolbar_buttons(article)
  end

  should 'display button to send email for all members of a community if the user is an environment administrator' do
    environment.add_admin(user)
    article = fast_create(TextArticle, :profile_id => profile.id)
    assert_not_equal [], plugin.article_extra_toolbar_buttons(article)
  end

  should 'the title be Send article to members' do
    profile.add_admin(user)
    article = fast_create(TextArticle, :profile_id => profile.id)
    assert_equal 'Send article to members', plugin.article_extra_toolbar_buttons(article)[:title]
  end

  should 'the icon be icon-menu-mail' do
    profile.add_admin(user)
    article = fast_create(TextArticle, :profile_id => profile.id)
    assert_equal 'icon-menu-mail', plugin.article_extra_toolbar_buttons(article)[:icon]
  end

  should 'not display button to send email for members if the user is not a community admin' do
    article = fast_create(TextArticle, :profile_id => profile.id)
    assert_equal [], plugin.article_extra_toolbar_buttons(article)
  end

  should 'not display button to send email for members if the article is a Blog' do
    profile.add_admin(user)
    article = fast_create(Blog, :profile_id => profile.id)
    assert_equal [], plugin.article_extra_toolbar_buttons(article)
  end

  should 'not display button to send email for members if the article is a Folder' do
    profile.add_admin(user)
    article = fast_create(Folder, :profile_id => profile.id)
    assert_equal [], plugin.article_extra_toolbar_buttons(article)
  end

  should 'not display button to send email for members if the article is a UploadedFile' do
    profile.add_admin(user)
    article = fast_create(UploadedFile, :profile_id => profile.id)
    assert_equal [], plugin.article_extra_toolbar_buttons(article)
  end

  should 'display button to send email for members if the article is a TextArticle' do
    profile.add_admin(user)
    article = fast_create(TextArticle, :profile_id => profile.id)
    assert_not_equal [], plugin.article_extra_toolbar_buttons(article)
  end

  should 'display button to send email for members if the article is a TextileArticle' do
    profile.add_admin(user)
    article = fast_create(TextileArticle, :profile_id => profile.id)
    assert_not_equal [], plugin.article_extra_toolbar_buttons(article)
  end

  should 'display button to send email for members if the article is a TinyMceArticle' do
    profile.add_admin(user)
    article = fast_create(TinyMceArticle, :profile_id => profile.id)
    assert_not_equal [], plugin.article_extra_toolbar_buttons(article)
  end

end
