class FeatureFlag
	class << self
		def test_name(request)
			@@test_name = request
		end
	end

	def tester?(request)
		request == @@test_name
	end
end

class FeatureInProgress < FeatureFlag
  test_name 'Katerina'

  def applies_to(request)
		tester?(request[:user_name])
  end
end

RSpec.describe FeatureFlag do
	it "returns hello when the person is a tester" do
		command_example = FeatureInProgress.new
		slack_data = {user_message: 'user request', user_name: 'Katerina'} 
		
    expect(command_example.applies_to(slack_data)).to eq(true)
  end
 end
