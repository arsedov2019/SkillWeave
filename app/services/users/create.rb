module Users
    class Create < ActiveInteraction::Base
      string :name, required: true
      string :patronymic, required: false
      string :email, required: true
      integer :age, required: true, greater_than: 0, less_than_or_equal_to: 90
      string :nationality, required: true
      string :country, required: true
      string :gender, required: true, inclusion: { in: ['male', 'female'] }
      string :surname, required: true
      array :interests, default: nil
      string :skills, default: nil
  
      validate :email_uniqueness
  
      def execute
        return self if invalid?
  
        user_full_name = [surname, name, patronymic].compact.join(' ')
        user_params = {
          full_name: user_full_name,
          email: email,
          age: age,
          nationality: nationality,
          country: country,
          gender: gender
        }
        user = User.new(user_params)
  
        if user.invalid?
          errors.merge!(user.errors)
          return self
        end
  
        user.save
        add_interests_and_skills(user)
        user.save ? user : errors.merge!(user.errors)
      end
  
      private
  
      def email_uniqueness
        if User.exists?(email: email)
          errors.add(:email, 'A user with this email address already exists.')
        end
      end
  
      def add_interests_and_skills(user)
        if interests.present?
          interests.each do |interest_name|
            interest = Interest.find_by(name: interest_name)
            user.interests << interest if interest
          end
        end
  
        if skills.present?
          skills.split(',').map(&:strip).each do |skill_name|
            skill = Skill.find_by(name: skill_name)
            user.skills << skill if skill
          end
        end
      end
    end
  end