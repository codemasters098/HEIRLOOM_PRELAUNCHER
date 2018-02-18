require 'users_helper'

class User < ActiveRecord::Base
  belongs_to :referrer, class_name: 'User', foreign_key: 'referrer_id'
  has_many :referrals, class_name: 'User', foreign_key: 'referrer_id'

  validates :email, presence: true, uniqueness: true, format: {
    with: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i,
    message: 'Invalid email format.'
  }
  validates :referral_code, uniqueness: true

  before_create :create_referral_code
  after_create :send_welcome_email

  REFERRAL_STEPS = [
    {
      'count' => 5,
      'html' => 'Garlic<br>Peeler',
      'class' => 'two',
      'image' =>  ActionController::Base.helpers.asset_path(
        '/assets/refer/garlicp.jpg')
    },
    {
      'count' => 10,
      'html' => 'Knife<br>Cover',
      'class' => 'three',
      'image' => ActionController::Base.helpers.asset_path(
        '/assets/refer/cover.png')
    },
    {
      'count' => 25,
      'html' => 'Cutting<br>Board',
      'class' => 'four',
      'image' => ActionController::Base.helpers.asset_path(
        '/assets/refer/product2.png')
    },
    {
      'count' => 50,
      'html' => 'Chefs<br>Apron',
      'class' => 'five',
      'image' => ActionController::Base.helpers.asset_path(
        '/assets/refer/product1.jpg')
    }
  ]

  private

  def create_referral_code
    self.referral_code = UsersHelper.unused_referral_code
  end

  def send_welcome_email
    UserMailer.delay.signup_email(self)
  end
end
