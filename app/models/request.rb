#encoding: utf-8

class Request < ActiveRecord::Base
  acts_as_paranoid

  self.primary_key = 'uid'
  has_uid 'req_', 24
end
