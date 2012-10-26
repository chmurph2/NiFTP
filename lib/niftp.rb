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
    options.reverse_merge!(default_options(options))
    raise "The :tries option must be > 0." if options[:tries] < 1
    retryable(retryable_options(options)) do
      ftp = instantiate_ftp_per_options(options)
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

  private

  def instantiate_ftp_per_options(options)
    (options[:ftps] ? Net::FTPFXPTLS.new : Net::FTP.new).tap do |ftp|
      ftp.passive = options[:passive]
    end
  end

  def default_options(options)
    {
      :username => "",
      :password => "",
      :port     => 21,
      :ftps     => false,
      :passive  => true,
      :timeout  => 30.seconds,
      :tries    => 2,
      :sleep    => 1.second,
      :on       => StandardError,
      :matching => /.*/
    }
  end

  def retryable_options(options)
    {
      :tries    => options[:tries],
      :sleep    => options[:sleep],
      :on       => options[:on],
      :matching => options[:matching]
    }
  end
end

# Alias for those that prefer a conventional module name.
Niftp = NiFTP
