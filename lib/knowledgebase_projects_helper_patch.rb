# -*- coding: utf-8 -*-

require_dependency 'projects_helper'

module KnowledgebaseProjectsHelperPatch
  def self.included(base) # :nodoc:
    base.send(:include, ProjectsHelperMethodsKnowledgebase)
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      alias_method_chain :project_settings_tabs, :knowledgebase
    end
  end
end

module ProjectsHelperMethodsKnowledgebase
  def project_settings_tabs_with_knowledgebase
    tabs = project_settings_tabs_without_knowledgebase
    action = {:name => 'knowledgebase',
              :action => :manage_knowledgebase,
              :partial => 'settings/knowledgebase_project_settings',
              :label => :knowledgebase_title}
    tabs << action if User.current.allowed_to?(:manage_knowledgebase, @project)
    tabs
  end
end