require 'singleton'
module Omg
  def omg!(*args)
    logger = OmgLogger.instance
    logger.log('')
    logger.log('~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    logger.log "OMG!"
    if args.length > 0
      args.each do |arg|
        logger.log arg.inspect
      end
    else
      logger.log "#{caller[1][/`([^']*)'/, 1]} called!"
    end
    logger.log('~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    logger.log('')
  end
end

Object.send(:include, Omg)

class OmgLogger
  include Singleton
  
  def log_with(logger, method)
    @logger = logger
    @method = method
  end
  
  def log(str)
    if @logger && @method
      @logger.send(@method.to_sym, str)
    elsif defined?(Rails) && Rails.logger
      if @method
        Rails.logger.send(@method.to_sym, str)
      else
        Rails.logger.debug(str)
      end
    else
      $stdout.puts(str)
    end
  end
end