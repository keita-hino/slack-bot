require 'vcr'
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  VCR.configure do |c|
      c.cassette_library_dir = 'spec/vcr_cassettes'
      c.allow_http_connections_when_no_cassette = true  #VCRブロック外のHTTP通信は許可する
      c.hook_into :webmock # or :fakeweb
      c.filter_sensitive_data('<SLACK_BOT_USER_TOKEN>') { ENV['SLACK_BOT_USER_TOKEN'] }
    end

  config.shared_context_metadata_behavior = :apply_to_host_groups

end
