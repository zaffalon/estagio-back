# require 'active_record' unless defined? ActiveRecord

module HasUid
  extend ActiveSupport::Concern

  def self.included(base)
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module ClassMethods

    def has_uid(prefix = '', length = 16, attribute = :uid)
      # Load securerandom only when has_secure_token is used.
      # require 'active_support/core_ext/securerandom'
      require 'base58'
      # define_method("regenerate_#{attribute}") { update_attributes attribute => self.class.generate_uid(prefix, length) }
      # after_create { self.send("#{attribute}=", self.class.generate_uid(prefix, length)) unless self.send("#{attribute}?")}

      # before_create {
      #   puts self.id
      #   self.send("#{attribute}=", self.id) unless self.send("#{attribute}?")
      # }

      before_create {
        # self.uid = prefix + SecureRandom.base58(length)
        self.send("#{attribute}=", prefix + SecureRandom.base58(length))
      }

    end
  end

  module InstanceMethods
    def save_with_uid(*args)
      begin
        self.save!(*args)
      rescue ActiveRecord::RecordNotUnique => e
        uid_attempts = uid_attempts.to_i + 1
        retry if uid_attempts < 5
        raise e, 'UID creation retries exhausted'
      rescue ActiveRecord::RecordInvalid => e
        false
      end
    end

    def update_uid(prefix = '', length = 16, attribute = :uid)
      require 'base58'

      begin
        self.update_attributes!(:"#{attribute}" => prefix + SecureRandom.base58(length))
      rescue ActiveRecord::RecordNotUnique => e
        uid_attempts = uid_attempts.to_i + 1
        retry if uid_attempts < 5
        raise e, 'UID creation retries exhausted'
      rescue ActiveRecord::RecordInvalid => e
        false
      end
    end
  end

end

ActiveRecord::Base.send(:include, HasUid)
