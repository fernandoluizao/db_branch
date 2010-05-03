require 'db_branch/adapters/base'
Dir['lib/db_branch/adapters/*.rb'].each { |file_name| require file_name }
