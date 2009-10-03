class User < ActiveRecord::Base
  concerned_with :states, :activation, :posting, :validation
  formats_attributes :bio
  
  has_one :restyle
  has_many :page_versions, :order=>'id desc'
  has_permalink :login
  

  named_scope :named_like, lambda {|name|
    { :conditions => ["users.display_name like ? or users.login like ?", 
                        "#{name}%", "#{name}%"] }}

  def self.prefetch_from(records)
    find(:all, :select => 'distinct *', :conditions => ['id in (?)', records.collect(&:user_id).uniq])
  end
  
  def self.index_from(records)
    prefetch_from(records).index_by(&:id)
  end


  def display_name
    n = read_attribute(:display_name)
    n.blank? ? login : n
  end

  alias_method :to_s, :display_name
  
  # this is used to keep track of the last time a user has been seen (reading a topic)
  # it is used to know when topics are new or old and which should have the green
  # activity light next to them
  #
  # we cheat by not calling it all the time, but rather only when a user views a topic
  # which means it isn't truly "last seen at" but it does serve it's intended purpose
  #
  # This is now also used to show which users are online... not at accurate as the
  # session based approach, but less code and less overhead.
  def seen!
    now = Time.now.utc
    self.class.update_all ['last_seen_at = ?', now], ['id = ?', id]
    write_attribute :last_seen_at, now
  end
  
  def to_param
    permalink || login
  end

  def openid_url=(value)
    write_attribute :openid_url, value.blank? ? nil : OpenIdAuthentication.normalize_identifier(value)
  end

  def using_openid
    self.openid_url.blank? ? false : true
  end
  
  def to_xml(options = {})
    options[:except] ||= []
    options[:except] << :email << :login_key << :login_key_expires_at << :password_hash << :openid_url << :activated << :admin
    super
  end

end
