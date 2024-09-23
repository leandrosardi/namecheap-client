require_relative '../lib/namecheap-client'
require_relative './config'

# Add a DNS record
begin
    CLIENT.add_dns_record('123leadsnow.com', 'A', 'w01.123leadsnow.com', '84.247.141.169')
    puts "DNS record added successfully."
  rescue StandardError => e
    puts "Error adding DNS record: #{e.message}"
  end
  