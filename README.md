# namecheap-client

# Namecheap Ruby Client

A simple Ruby client library for interacting with the [Namecheap API](https://www.namecheap.com/support/api/intro/), allowing you to manage your domains programmatically.

## Features

- **List Domains**: Retrieve a list of all domains in your Namecheap account.
- **Add DNS Records**: Add DNS records to a specified domain.
- **Remove DNS Records**: Remove DNS records from a specified domain.

## Installation

```
gem install namecheap-client
```

## Usage

1. Require the Library:

```ruby
require 'namecheap_client'
```

2. Create an instance of NamecheapClient with your API credentials:

```ruby
client = NamecheapClient.new(
  api_user: 'your_api_user',       # Usually your Namecheap username
  api_key: 'your_api_key',         # Your Namecheap API key
  username: 'your_username',       # Your Namecheap username
  client_ip: 'your_whitelisted_ip' # The IP you've whitelisted in Namecheap API settings
)
```

**Note:** Ensure your IP address is whitelisted in your Namecheap account under Profile > Tools > API Access.

## List All Domains

Retrieve a list of all domains in your account:

```ruby
begin
  domains = client.list_domains
  puts "Your domains:"
  domains.each do |domain|
    puts "#{domain['Name']} - Expires: #{domain['Expires']}"
  end
rescue StandardError => e
  puts "Error fetching domains: #{e.message}"
end
```

## Add a DNS Record

Add a DNS record to a domain:

```ruby
begin
  client.add_dns_record('example.com', 'A', 'subdomain', '192.0.2.1')
  puts "DNS record added successfully."
rescue StandardError => e
  puts "Error adding DNS record: #{e.message}"
end
```

**Parameters:**

- domain: The domain name (e.g., 'example.com').
- record_type: The DNS record type (e.g., 'A', 'CNAME', 'TXT').
- host_name: The host name or subdomain (e.g., 'www', '@', 'subdomain').
- address: The record value (e.g., IP address for 'A' records).
- ttl: (Optional) Time to live in seconds (default is '1800').

## Remove a DNS Record

Remove a DNS record from a domain:

```ruby
begin
  client.remove_dns_record('example.com', 'A', 'subdomain')
  puts "DNS record removed successfully."
rescue StandardError => e
  puts "Error removing DNS record: #{e.message}"
end
```

**Parameters:**

- domain: The domain name.
- record_type: The DNS record type.
- host_name: The host name or subdomain.

## Error Handling

All methods raise a StandardError with an error message if the API call fails. You should handle exceptions as shown in the usage examples.

## Notes

- **IP Whitelisting:** Your client IP must be whitelisted in your Namecheap account to use the API.

- **API Limits:** Be mindful of Namecheap's API rate limits to prevent being throttled.

- **Thread Safety:** The client is not thread-safe. If using in a multi-threaded environment, implement appropriate synchronization.

- **Secure Storage:** Store your API credentials securely. Avoid hardcoding them in your codebase.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/leandrosardi/namecheap-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](https://www.contributor-covenant.org/).

### How to Contribute

1. **Fork the Repository:** Click the "Fork" button at the top right of the repository page.

2. **Clone Your Fork:**

```
git clone https://github.com/lenadrosardi/namecheap-client.git
cd namecheap-client
```

3. **Create a Feature Branch:**

```
git checkout -b feature/my-new-feature
```

4. **Make Your Changes:** Implement your feature or bug fix.

5. **Commit Your Changes:**

```
git commit -am 'Add new feature'
```

6. **Push to the Branch:**

```
git push origin feature/my-new-feature
```

7. **Open a Pull Request:** Go to your fork on GitHub and click the "New pull request" button.


## License

This project is licensed under the [MIT License](/LICENSE).

---

library at your own risk, and make sure to comply with Namecheap's API Terms of Use.


## Contact

For questions or suggestions, feel free to open an issue or contact me at [leandro@massprospecting.com](mailto:leandro@massprospecting.com).

---

Happy coding!