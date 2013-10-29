# encoding: utf-8
class KnowledgebaseController < ApplicationController
  unloadable

  #Authorize against global permissions defined in init.rb
  before_filter :authorize_global, :except => [:index, :show]
  before_filter :authorize_global, :only   => [:index, :show], :unless => :allow_anonymous_access?

  rescue_from ActionView::MissingTemplate, :with => :force_404
  rescue_from ActiveRecord::RecordNotFound, :with => :force_404

  def index
    begin
      summary_limit = Setting['plugin_redmine_knowledgebase']['knowledgebase_summary_limit'].to_i
    rescue
      summary_limit = 5
    end

    @categories = KbCategory.find(:all)
    @articles_newest   = KbArticle.find(:all, :limit => summary_limit, :order => 'created_at DESC')
    @articles_updated  = KbArticle.find(:all, :limit => summary_limit, :conditions => ['created_at <> updated_at'], :order => 'updated_at DESC')

    #FIXME the following method still requires ALL records to be loaded before being filtered.

    a = KbArticle.find(:all, :include => :viewings).sort_by(&:view_count)
    a = a.drop(a.count - summary_limit) if a.count > summary_limit
    @articles_popular  = a.reverse
    a = KbArticle.find(:all, :include => :ratings).sort_by(&:rated_count)
    a = a.drop(a.count - summary_limit) if a.count > summary_limit
    @articles_toprated = a.reverse

    @tags = KbArticle.tag_counts

    #For default search
    project = Project.first(:order => 'id')
    kbarticle = KbArticle.first(:order => 'project_id')
    if (project ? project.id : 0) != (kbarticle ? kbarticle.project_id : 0)
      KbArticle.update_all :project_id => Project.first(:order => 'id').id
    end
  end

  def search
    @categories = []
    @articles = []
    categories_query_params = ""
    articles_query_params = ""
    @search_words = URI.decode(params[:q].to_s).gsub(/　/," ").split(nil)
    @search_words.each do |search_word|
      wild_search_word = '"%' + URI.decode(search_word.to_s) + '%"'
      categories_query_params += " (title LIKE #{wild_search_word} OR description LIKE #{wild_search_word}) " if wild_search_word != '"%%"'
      articles_query_params += " (title LIKE #{wild_search_word} OR summary LIKE #{wild_search_word} OR content LIKE #{wild_search_word}) " if wild_search_word != '"%%"'
    end
    if params[:and_or] == "AND" then
      categories_query_params = categories_query_params.gsub(")  (", ") AND (")
      articles_query_params = articles_query_params.gsub(")  (", ") AND (")
    else
      categories_query_params = categories_query_params.gsub(")  (", ") OR (")
      articles_query_params = articles_query_params.gsub(")  (", ") OR (")
    end
    p @search_words
    @categories = KbCategory.find(:all, :conditions => categories_query_params) if categories_query_params != ""
    @articles = KbArticle.find(:all, :conditions => articles_query_params, :include => :ratings).sort_by(&:rated_average) if articles_query_params != ""
  end

#########
protected
#########
  def is_user_logged_in
    if !User.current.logged?
      render_403
    end
  end

  def allow_anonymous_access?
    Setting['plugin_redmine_knowledgebase']['knowledgebase_anonymous_access'].to_i == 1
  end

#######
private
#######

  def force_404
    render_404
  end

end

