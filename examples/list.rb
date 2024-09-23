require_relative '../lib/namecheap-client'
require_relative './config'

# List all domains
begin
  domains = CLIENT.list_domains
  puts "Your domains:"
  domains.each do |domain|
    puts "#{domain['Name']} - Expires: #{domain['Expires']}"
  end
rescue StandardError => e
  puts "Error: #{e.message}"
end
  