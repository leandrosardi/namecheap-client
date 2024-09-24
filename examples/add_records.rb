require_relative '../lib/namecheap-client'
require_relative './config'

# Add a DNS record
begin
    i = 54
    while i<250
      i += 1
      print "#{i}... "
      sleep 1
      CLIENT.add_dns_record('123leadsnow.com', 'A', "many#{i}.123leadsnow.com", "84.247.141.#{i}")
      puts "DNS record added successfully."  
    end
  rescue StandardError => e
    puts "Error adding DNS record: #{e.message}"
  end
  