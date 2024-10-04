using DotEnv
using MySQL

DotEnv.load!()

conn = DBInterface.connect(
    MySQL.Connection,
    ENV["MYSQL_HOST"],
    ENV["MYSQL_USER"],
    ENV["MYSQL_PASSWORD"],
    db = ENV["MYSQL_DATABASE"]
)
