namespace :db do
  namespace :branch do

    desc "Saves a db dump for the current git branch"
    task :save => :environment do
      branch = current_git_branch
      puts "Saving db dump: branch=#{branch}, environment=#{RAILS_ENV} ..."
      dump_database_for_branch(branch)
      puts "Done."
    end
  
    desc "Restores a db dump for the current git branch"
    task :restore => :environment do
      branch = current_git_branch
      puts "Restoring db dump: branch=#{branch}, environment=#{RAILS_ENV} ..."
      restore_database_for_branch(branch)
      puts "Done."
    end
  
    desc "Lists all branch-specific db dumps"
    task :list => :environment do
      dir = dump_path
      dir.children.each {|c| puts c.basename } if dir.exist?
    end

    desc "Delete a branch dump using 'filename' parameter"
    task :delete => :environment do
      dump = dump_path.join(ENV['filename'])
      puts "Deleting #{dump} ..."
      system "rm #{dump}"
      puts "Done."
    end
    
    desc "Delete all branch dumps"
    task :delete_all => :environment do
      puts "Deleting all dumps ..."
      system "rm -r #{dump_path}"
      puts "Done."
    end
  end
  
end

def adapter_for(config, pathname)
  klass = case config['adapter']
    when 'mysql'
      DbBranch::Adapters::Mysql
    when 'postgresql'
      DbBranch::Adapters::Postgresql
    when 'sqlite3'
      DbBranch::Adapters::Sqlite
    else
      raise "Don't know how to dump/restore '#{config['adapter']}'"
  end
  klass.new(config, pathname)
end

def current_git_branch
  matches = `git branch`.match /^\* ([^(]\S+)$/
  branch = matches && matches[1]
  branch || fatal_error!("Current git branch not found!")
end

def dump_path
  Pathname("#{RAILS_ROOT}/tmp/branch-dumps")
end

def branch_dump_pathname(branch)
  dump_path.join("#{branch}-#{RAILS_ENV}.sql")
end

def dump_database_for_branch(branch)
  config = current_db_config
  pathname = branch_dump_pathname(branch)
  pathname.dirname.mkpath
  adapter = adapter_for(current_db_config, pathname)
  adapter.dump
end

def restore_database_for_branch(branch)
  config = current_db_config
  pathname = branch_dump_pathname(branch)
  fatal_error!("No db dump exists for current branch!") unless pathname.exist?
  Rake::Task['db:drop'].invoke
  Rake::Task['db:create'].invoke
  adapter = adapter_for(current_db_config, pathname)
  adapter.restore
end

def current_db_config
  ActiveRecord::Base.configurations[RAILS_ENV]
end

def fatal_error!(msg)
  puts("[ERR] #{msg}"); exit!
end
