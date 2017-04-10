require 'bamboo_cache'

RSpec.describe BambooCache do
  let(:cache) {BambooCache.new}
  
  it "caches employees correctly" do
    cache.store_employees(["test"])
    expect(cache.employees).to eq(["test"])
  end

  it "caches whos out correctly" do
    cache.store_whos_out(["test"])
    expect(cache.whos_out).to eq(["test"])
  end

  it "knows when it doesn't need to cache whos_out" do
    cache.store_whos_out(["test"])
    expect(cache.whos_out_needs_cache?).to eq(false)
  end

  it "knows when it doesn't need to cache employees" do
    cache.store_employees(["test"])
    expect(cache.employees_needs_cache?).to eq(false)
  end
end
