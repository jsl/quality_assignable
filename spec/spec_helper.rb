require 'rubygems'
require 'mocha'
require 'spec'

require File.join(File.dirname(__FILE__), %w[.. lib quality_assignable])

Spec::Runner.configure do |config|
  config.mock_with(:mocha)
end

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :dbfile => ":memory:"
)

ActiveRecord::Migration.verbose = false
