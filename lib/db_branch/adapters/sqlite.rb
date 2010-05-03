module DbBranch
  module Adapters
    
    class Sqlite < Base
      
      def dump
        # dump_cmd = "sqlite3 #{config['database']} .dump > #{pathname}"
        dump_cmd = "cp -f #{config['database']} #{pathname}"
        run(dump_cmd)
      end
      
      def restore
        # restore_cmd = "sqlite3 #{config['database']} < #{pathname} "
        restore_cmd = "cp -f #{pathname} #{config['database']}"
        run(dump_cmd)
      end
      
    end
    
  end
end
