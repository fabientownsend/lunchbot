class FeatureFlag
  @@tester_bucket = {}

  class << self
    def release_for(*feature_testers)
      @@tester_bucket[name] = []

      feature_testers.each do |feature_tester|
        @@tester_bucket[name] << feature_tester
      end
    end
  end

  def feature_access?(request)
    @@tester_bucket[self.class.name].include?(request)
  end
end
