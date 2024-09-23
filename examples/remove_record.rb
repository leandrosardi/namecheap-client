require_relative '../lib/namecheap-client'
require_relative './config'

# Remove a DNS record
begin
    CLIENT.remove_dns_record('123leadsnow.com', 'A', 'w01.123leadsnow.com')
    puts "DNS record removed successfully."
rescue StandardError => e
    puts "Error removing DNS record: #{e.message}"
end
