class ReportError < Hyperstack::ControllerOp

  def self.logger
    @logger ||= Logger.new(Rails.root.join('log/client_errors.log'))
  end

  def log_error(*args)
    Rails.logger.error(*args)
    self.class.logger.error(*args)
  end

  param :message
  param :backtrace
  step do
    log_error "***************************************************************************"
    params.backtrace.each { |l| log_error l }
    log_error "***************************************************************************\n"
  end
end
