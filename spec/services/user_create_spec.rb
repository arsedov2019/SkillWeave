require 'rails_helper'

RSpec.describe Users::Create do
  let(:params) do
    {
      name: 'John',
      patronymic: 'Doe',
      email: 'john@example.com',
      age: 30,
      nationality: 'American',
      country: 'USA',
      gender: 'male',
      surname: 'Smith',
      interests: ['Sports', 'Music'],
      skills: 'Programming,Ruby'
    }
  end

  before do
    Interest.create(name: 'Sports')
    Interest.create(name: 'Music')
    Skill.create(name: 'Programming')
    Skill.create(name: 'Ruby')
  end

  it 'creates a user with the given parameters' do
    result = Users::Create.new(params).execute
    expect(result).to be_a(User)
    expect(result.full_name).to eq('Smith John Doe')
    expect(result.email).to eq('john@example.com')
    expect(result.age).to eq(30)
    expect(result.nationality).to eq('American')
    expect(result.country).to eq('USA')
    expect(result.gender).to eq('male')
    expect(result.interests.pluck(:name)).to match_array(['Sports', 'Music'])
    expect(result.skills.pluck(:name)).to match_array(['Programming', 'Ruby'])
  end

  it 'does not create a user if email already exists' do
    User.create(full_name: 'Existing User', email: 'john@example.com', age: 25, nationality: 'American', country: 'USA', gender: 'male')
    invalid_params = params.merge(email: 'john@example.com')
    result = Users::Create.new(invalid_params).execute
    expect(result).not_to be_a(User)
    expect(result.errors[:email]).to include('A user with this email address already exists.')
  end

  it 'does not create a user if age is invalid' do
    invalid_params = params.merge(age: -5)
    result = Users::Create.new(invalid_params).execute
    expect(result).not_to be_a(User)
    expect(result.errors[:age]).to include('must be greater than 0')
  end

  it 'does not create a user if gender is invalid' do
    invalid_params = params.merge(gender: 'other')
    result = Users::Create.new(invalid_params).execute
    expect(result).not_to be_a(User)
    expect(result.errors[:gender]).to include('is not included in the list')
  end
end