# -*- coding: utf-8 -*-

class KnowledgebaseIssueHooks < Redmine::Hook::Listener
  class KnowledgebaseIssueViewListener < Redmine::Hook::ViewListener
    # 関連性の高い記事の表示機能
    render_on :view_issues_show_description_bottom, :partial => 'issues/knowledgebase_issue_extensions_form', :multipart => true
  end
end