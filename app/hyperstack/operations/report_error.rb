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
  param :info

  step do
    params.backtrace << params.message if params.backtrace.empty?
    log_error "***************************************************************************"
    params.backtrace.each { |l| log_error l }
    log_error params.info
    log_error "***************************************************************************\n"
  end
end
