configure do

  if Sinatra::Application.development?
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  if Sinatra::Application.development?
    set :database, {
      adapter: "sqlite3",
      database: "db/db.sqlite3"
    }
  else
    db_url = 'postgres://pkibjnrsvzbzxi:503b0440e1a6ec1dda03ab0ffd55eb9e72ba2652e9400be470dce5a308f84137@ec2-18-214-140-149.compute-1.amazonaws.com:5432/d7a6j7s8gpbook'
    db = URI.parse(ENV['DATABASE_URL'] || db_url)
    set :database, {
      adapter: "postgresql",
      host: db.host,
      username: db.user,
      password: db.password,
      database: db.path[1..-1],
      encoding: 'utf8'
    }
  end

  Dir[APP_ROOT.join('app', 'models', '*.rb')].each do |model_file|
    filename = File.basename(model_file).gsub('.rb', '')
    autoload ActiveSupport::Inflector.camelize(filename), model_file
  end

end