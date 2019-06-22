# typed: true
class FeatureFlag
  @@tester_bucket = {}

  def self.release_for(*feature_testers)
    @@tester_bucket[name] = []

    feature_testers.each do |feature_tester|
      @@tester_bucket[name] << feature_tester
    end
  end

  def feature_access?(tester)
    @@tester_bucket[self.class.name].include?(tester)
  end
end
