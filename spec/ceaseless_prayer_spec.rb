require 'spec_helper'

describe 'the application', js: true do
  it "will load the home page" do
    visit '/'
    expect(page).to have_content('Join us in world wide prayer for healing')
    expect(page).to have_content('Join people from around the world')
    expect(page).to have_content('PRAY NOW!')
  end
end
