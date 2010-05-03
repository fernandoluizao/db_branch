module DbBranch
  module Adapters
    
    class Mysql < Base
      
      def dump
        dump_cmd = "/usr/bin/env mysqldump --skip-add-locks -u#{config['username']}"
        dump_cmd << " -p'#{config['password']}'" unless config['password'].blank?
        dump_cmd << " -h #{config['host']}" unless config['host'].blank?
        dump_cmd << " #{config['database']} > #{pathname}"
        run(dump_cmd)
      end
      
      def restore
        restore_cmd = "/usr/bin/env mysql -u#{config['username']}"
        restore_cmd << " -p'#{config['password']}'" unless config['password'].blank?
        restore_cmd << " #{config['database']} < #{pathname}"
        run(restore_cmd)
      end
      
    end
  end
end

