require 'cuba'

Cuba.define do
  def read_fixture(*path)
    filepath = [
      File.dirname(__FILE__), 
      'fixtures',
      *path,
    ].join('/') + '.json'

    File.read(
      filepath
    )
  end

  on get do
    on 'api/guilds' do
      on ':id' do |id|
        on root do
          res.write read_fixture('guilds', id)
        end

        on 'members' do
          on root do
            res.write read_fixture('members', 'list')
          end

          on 'find', param("email") do |email|
            res.write read_fixture('members', 1)
          end
        end
      end

      on root do
        res.write read_fixture('guilds', 'list')
      end
    end

    on 'api/batches' do 
      on ':id' do |id|
        res.write read_fixture('batches', id)
      end

      on root do
        res.write read_fixture('batches', 'list')
      end
    end

    on 'api/tasks' do 
      on ':id' do |id|
        res.write read_fixture('tasks', id)
      end

      on root do
        res.write read_fixture('tasks', 'list')
      end
    end

    on 'api/wallets' do 
      on ':id' do |id|
        res.write read_fixture('wallets', id)
      end

      on root do
        res.write read_fixture('wallets', 'list')
      end
    end

    on 'api/members/:id' do |id|
      res.write read_fixture('members', id)
    end
  end

  on post do
    on 'api/guilds/:guild_id/invites' do |guild_id|
      res.write read_fixture('invites', 'create')
    end

    on 'api/guilds/:guild_id/batches' do |guild_id|
      if guild_id == '1'
        res.write read_fixture('batches', 'create')
      else
        res.status = 422
        res.write read_fixture('batches', 'bad_params')
      end
    end

    on 'api/batches/:id/debits' do |id|
      res.write read_fixture('batches', 'pay')
    end
  end

  on delete do
    on 'api/guilds/:guild_id/members/:id' do |guild_id, id|
      res.write read_fixture('members', 'removed')
    end

    on 'api/batches/:id' do |id|
      res.write read_fixture('batches', 'cancel')
    end
  end
end

#If this file is loaded from the command line, start the server 
Rack::Handler::WEBrick.run(Cuba) if $PROGRAM_NAME == __FILE__
