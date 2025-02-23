class User < ApplicationRecord
    has_many :user_interests
    has_many :interests, through: :user_interests
    has_many :user_skills
    has_many :skills, through: :user_skills

    validates :age, numericality: { greater_than: 0, less_than_or_equal_to: 90 }
    validates :gender, inclusion: { in: %w[male female] }
  end