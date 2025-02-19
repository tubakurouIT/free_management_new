class FreePost < ApplicationRecord
  
  validates :body,presence:true,length:{maximum:200}
  
  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}

  belongs_to :member
  belongs_to :group, optional: true
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one_attached :image

  def favorited_by?(member)
    favorites.exists?(member_id: member.id)
  end

  def get_image
    (image.attached?) ? image : 'no_image.jpg'
  end

  def self.search_for(content, method)
    if method == 'perfect'
      FreePost.where(body: content)
    elsif method == 'forward'
      FreePost.where('body LIKE ?', content + '%')
    elsif method == 'backward'
      FreePost.where('body LIKE ?', '%' + content)
    else
      FreePost.where('body LIKE ?', '%' + content + '%')
    end
  end
    
end
