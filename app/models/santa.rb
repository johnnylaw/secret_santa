class Santa < ApplicationRecord
  before_validation :ensure_santa_has_permalink

  belongs_to :recipient, class_name: 'Santa', optional: true
  belongs_to :banned_recipient, class_name: 'Santa', optional: true

  validates :name, presence: true
  validates :permalink, presence: true
  validates :recipient_id, uniqueness: true, allow_nil: true

  def ensure_santa_has_permalink
    self.permalink ||= SecureRandom.uuid
  end

  def self.reset!
    update_all!(recipient_id: nil)
  end

  def self.scramble!
    reset!
    all_ids = pluck(:id)
    all_ids.dup.each do |id|
      santa = find(id)
      allowed_ids = all_ids - [santa.id, santa.banned_recipient_id]
      santa.recipient_id = allowed_ids.sample
      santa.save!
      all_ids.delete(santa.recipient_id)
    end

    scramble! if find_by(recipient_id: nil)
    check
  end

  def self.check
    raise 'Not all santas have a recipient' if find_by(recipient_id: nil)
    raise 'Banned recipient is recipient' if find_by('banned_recipient_id = recipient_id')
    raise 'Duplicate recipient' if pluck(:recipient_id).uniq.size != count
    true
  end

  def self.to_links(host)
    Santa.select(:name, :permalink).map do |santa|
      { name: santa.name, link: "#{host}/#{santa.permalink}" }
    end
  end
end
