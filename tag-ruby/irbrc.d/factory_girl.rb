def fg_boot
  begin
    require 'factory_girl_rails'
    include FactoryGirl::Syntax::Methods
  rescue LoadError
    require 'factory_bot_rails'
    include FactoryBot::Syntax::Methods
  end
end
