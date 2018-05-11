require 'feature_flag'

class FeatureInProgress < FeatureFlag
  release_for 'user 1'

  def has_access?(request)
    feature_access?(request[:user_name])
  end
end

class SecondFeatureInProgress < FeatureFlag
  release_for 'user 1', 'user 2'

  def has_access?(request)
    feature_access?(request[:user_name])
  end
end

RSpec.describe FeatureFlag do
  it "returns true when a user has access to a feature" do
    command_example = FeatureInProgress.new

    slack_data = { user_name: 'user 1' }

    expect(command_example.has_access?(slack_data)).to eq(true)
  end

  it "returns false when a user has not access to a feature" do
    command_example = FeatureInProgress.new

    slack_data = { user_name: 'user 2' }

    expect(command_example.has_access?(slack_data)).to eq(false)
  end

  it "multiple testers can have access to one feature" do
    command_example = SecondFeatureInProgress.new

    user_one = { user_name: 'user 1' }
    user_two = { user_name: 'user 2' }

    expect(command_example.has_access?(user_one)).to eq(true)
    expect(command_example.has_access?(user_two)).to eq(true)
  end
end
