if ENV["APP_ENV"] == "test"
    db_name = ENV["MYSQL_DATABASE_TEST"]
elseif ENV["APP_ENV"] == "hajj"
    db_name = ENV["MYSQL_DATABASE"]
end

conn = DBInterface.connect(
    MySQL.Connection,
    ENV["MYSQL_HOST"],
    ENV["MYSQL_USER"],
    ENV["MYSQL_PASSWORD"],
    db = db_name
)
