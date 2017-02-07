require "net/ftp"
require "double_bag_ftps"
require "retryable"
require "timeout"

# Abstracts away File Transfer Protocol plumbing, such as establishing and
# closing connections.
module NiFTP

  # Connects to the +host+ FTP server, executes the given block then closes
  # the connection.
  #
  # See the README for available options and examples.
  def ftp(host, options = {}, &block)
    options = default_options.merge(options)
    raise "The :tries option must be > 0." if options[:tries] < 1
    Retryable.retryable(retryable_options(options)) do
      ftp = instantiate_ftp_per_options(options)
      begin
        login_with_timeout(ftp, host, options)
        yield ftp if ftp && block_given?
      ensure
        ftp.close if ftp
      end
    end
  end

  private

  def login_with_timeout(ftp, host, options)
    Timeout::timeout(options[:timeout]) do
      ftp.connect host, options[:port]
      ftp.login options[:username], options[:password]
    end
  end

  def instantiate_ftp_per_options(options)
    (options[:ftps] ? DoubleBagFTPS.new : Net::FTP.new).tap do |obj|
      if options[:ftps]
        if options[:ftps_mode]
          obj.ftps_mode = options[:ftps_mode]
        end

        if options[:ssl_context_params]
          obj.ssl_context = DoubleBagFTPS.create_ssl_context(
            options[:ssl_context_params]
          )
        end
      end

      obj.passive = options[:passive]
    end
  end

  def default_options
    {
      :username => "",
      :password => "",
      :port     => 21,
      :ftps     => false,
      :passive  => true,
      :timeout  => 30, # seconds
      :tries    => 2,
      :sleep    => 1,  # second
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
