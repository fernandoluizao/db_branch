module DbBranch
  module Adapters
    
    class Postgresql < Base
      
      def dump
        # TODO: use .pgpass file?
        ENV['PGPASSWORD'] = config['password'].to_s unless config['password'].blank?
        dump_cmd  = "pg_dump -U #{config['username']}"
        dump_cmd << " -h #{config['host']}" if config['host']
        dump_cmd << " -p #{config['port']}" if config['port']
        dump_cmd << " -F c -b" # dump_flags
        dump_cmd << " #{config['database']} > #{pathname}"
        run(dump_cmd)
        ENV['PGPASSWORD'] = nil
      end
      
      def restore
        ENV['PGPASSWORD'] = config['password'].to_s unless config['password'].blank?
        restore_cmd  = "pg_restore -U #{config['username']}"
        restore_cmd << " -h #{config['host']}" if config['host']
        restore_cmd << " -p #{config['port']}" if config['port']
        restore_cmd << " -d #{config['database']} < #{pathname}"
        run(restore_cmd)
        ENV['PGPASSWORD'] = nil
      end
      
    end
    
  end
end
