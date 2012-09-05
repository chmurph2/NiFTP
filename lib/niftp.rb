require "net/ftp"
require "ftpfxp"
require "retryable"
require "timeout"
require "active_support/core_ext"

# Abstracts away File Transfer Protocol plumbing, such as establishing and
# closing connections.
module NiFTP

  # Connects to the +host+ FTP server, executes the given block then closes
  # the connection.
  #
  # See the README for available options and examples.
  def ftp(host, options = {}, &block)
    options.reverse_merge!(
      :username => "", :password => "", :port => 21, :ftps => false,
      :passive => true, :timeout => 30.seconds, :tries => 2, :sleep => 1.second,
      :on => StandardError,  :matching => /.*/)
    raise "The :tries option must be > 0." if options[:tries] < 1
    retryable(:tries => options[:tries], :sleep => options[:sleep],
    :on => options[:on], :matching => options[:matching]) do
      ftp = options[:ftps] ? Net::FTPFXPTLS.new : Net::FTP.new
      ftp.passive = options[:passive]
      begin
        Timeout::timeout(options[:timeout]) do
          ftp.connect host, options[:port]
          ftp.login options[:username], options[:password]
        end
        yield ftp if ftp.present? && block_given?
      ensure
        ftp.try(:close)
      end
    end
  end
end

# Alias for those that prefer a conventional module name.
Niftp = NiFTP
