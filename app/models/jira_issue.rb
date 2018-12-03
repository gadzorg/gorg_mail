#!/bin/env ruby
# encoding: utf-8

require 'active_resource'
class JiraIssue < ActiveResource::Base
  self.site = Rails.application.secrets.jira_url
  self.prefix= "/rest/api/2/"
  self.element_name = "issue"
  self.collection_name = "issue"
  self.user = Rails.application.secrets.jira_user
  self.password = Rails.application.secrets.jira_password
  unless Rails.application.secrets.proxy
    self.proxy = Rails.application.secrets.proxy
  end



end