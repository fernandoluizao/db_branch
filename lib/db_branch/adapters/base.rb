module DbBranch
  module Adapters
    
    class Base
      
      attr_reader :config, :pathname
      
      def initialize(config, pathname, verbose = false)
        @config = config
        @pathname = Pathname(pathname)
        # @verbose = verbose
      end

     private
      
      def run(command)
        # puts command if @verbose
        system command
      end
      
    end
    
  end
end
