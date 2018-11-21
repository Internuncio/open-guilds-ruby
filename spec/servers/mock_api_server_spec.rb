require 'spec_helper'

RSpec.describe 'Endpoints', type: :feature do
  around &method(:with_fake_server)

  get_paths = %w(
    api/guilds
    api/guilds/1
    api/guilds/1/members
    api/guilds/1/members/find?email="email@example.com"
    api/batches
    api/batches/1
    api/tasks
    api/tasks/1
    api/members/1
  )

  get_paths.each do |path|
    describe path do
      it 'should return a successful status' do
        visit path

        expect(page.status_code).to eq 200
      end
    end
  end
end
