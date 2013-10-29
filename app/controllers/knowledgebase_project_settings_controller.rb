class KnowledgebaseProjectSettingsController < ApplicationController
  unloadable
  layout 'base'

  before_filter :find_project, :authorize, :find_user

  def update
    setting = KbProjectSettings.find_or_create @project.id
    setting.flg_involved_articles = params[:flg_involved_articles]
    setting.show_involved_articles_count = params[:show_involved_articles_count]
    setting.use_columns_for_default_search = params[:use_columns_for_default_search].keys if params[:use_columns_for_default_search].present?
    setting.any_keyword = params[:any_keyword]
    begin
      setting.save!
      flash[:notice] = l(:notice_successful_update)
    rescue
      flash[:error] = l(:notice_failed_update)
    end

    redirect_to :controller => 'projects', :action => "settings", :id => @project, :tab => "knowledgebase"
  end

  private
  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find(params[:id])
  end

  def find_user
    @user = User.current
  end
end
