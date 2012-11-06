NiFTP, a Ruby gem, makes Ruby's decidedly un-nifty Net::FTP library easier to
use. It abstracts away the FTP plumbing, such as establishing and closing
connections. Options include retrying your commands on flakey FTP servers, and
forced timeouts. FTP Secure (FTPS) is also supported.

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/chmurph2/NiFTP)

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
    require 'niftp'
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
* **tries**: The number of times to try the given FTP commands upon any
  exception, before raising the exception (Default: 2, meaning it will *retry
  once* upon any exception).
* **sleep**: The number of seconds to sleep in between tries (default: 1).
* **on**: An array of errors to limit when the code block is retried
  (default: StandardError).  See the
  [retryable](https://github.com/nfedyashev/retryable) gem for usage details
* **matching**: An exception message regex to limit when the code block is
  retried (default: /.*/).  See the
  [retryable](https://github.com/nfedyashev/retryable) gem for usage details
* **timeout**: The number of seconds to wait before timing out authentication
  (default: 30). Use 0 to disable the authentication timeout.
* **passive**: Set to false to prevent a connection in passive mode (default:
  true).

## Caveats

  Setting the :tries option to 0 will raise a runtime error, otherwise the
  codeblock would never execute.


## Testing

Tests are written with Shoulda and Mocha. This gem is tested in Ruby 1.8.7
(REE) and 1.9.2.