module Heroku::Command
  class Dashmin < BaseWithApp
    Help.group('Dashmin') do |group|
      group.command 'dashmin', 'create a dashboard for the current app'
    end

    def initialize(*args)
      super
      @config_vars = heroku.config_vars(app)
      @dashmin_url = @config_vars['DASHMIN_URL']
      abort ' !   Please add the dashmin addon first.' unless @dashmin_url
    end

    def index
      puts 'Dashmin must now store an encrypted version of the database URL of your application'
      puts 'Do you allow this? (yes/no)'
      print '> '
      answer = STDIN.gets
      if ['yes', 'y'].include? answer.chomp.downcase
        RestClient::Resource.new(@dashmin_url).put :uri => @config_vars['DATABASE_URL']
        puts 'Successfully enabled Dashmin for the current app.'
      else
        puts 'Plugin execution aborted.'
      end
    end

  end
end
