NiFTP, a Ruby gem, makes Ruby's decidedly un-nifty Net::FTP library easier to
use. It abstracts away the FTP plumbing, such as establishing and closing
connections. Options include retrying your commands on flakey FTP servers, and
forced timeouts. FTP Secure (FTPS) is also supported.

## Usage
    # Without NiFTP:
    begin
      client = Net::FTP.new("localhost")
      client.list
    ensure
      client.try(:close)
    end

    # With NiFTP:
    ftp("localhost") { |client| client.list }

    # A more concrete example:

    # Mixin the +NiFTP+ module, which provides the +ftp+ method.
    class SomeObject
      include NiFTP

      def ftp_stuff
        # get a file from an FTP Secure (FTPS) server
        ftp("ftp.secure.com", { username: "some_user", password: "FTP_FTL",
                                ftps: true }) do |client|
          files = client.list('n*')
          # ...
          file = client.getbinaryfile('nif.rb-0.91.gz', 'nif.gz', 1024)
          # ...
        end
      end
    end

## Options

* **username**: The user name, if required by the host (default: "").
* **password**: The password, if required by the host (default: "").
* **port**: The port for the host (default: 21).
* **ftps**: Set to true if connecting to a FTP Secure server (default: false).
* **retries**: The number of times to re-try the given FTP commands upon any
  exception, before raising the exception (Default: 1).
* **timeout**: The number of seconds to wait before timing out (default: 5).
  Use 0 to disable the timeout.
* **passive**: Set to false to prevent a connection in passive mode (default:
  true).

## Caveats

  Based on the way the [retryable]("https://github.com/nfedyashev/retryable")
  gem works, any FTP commands will be retried at least once upon any
  exception. Setting the :retries option to 0 will raise a runtime error.  I'm
  fine with this for now as I prefer this behavior.

## Testing

Tests are written with Shoulda and Mocha. This gem is tested in Ruby 1.8.7
(REE) and 1.9.2.