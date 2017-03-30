require 'spec_helper'

describe Collectible do
  it 'has a version number' do
    expect(Collectible::VERSION).not_to be nil
  end
end
