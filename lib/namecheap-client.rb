require 'net/http'
require 'uri'
require 'nokogiri'
#require 'pry'

class NamecheapClient
  API_URL = 'https://api.namecheap.com/xml.response'

  def initialize(api_user:, api_key:, username:, client_ip:)
    @api_user = api_user
    @api_key = api_key
    @username = username
    @client_ip = client_ip
  end

  # List all domains in the account
  def list_domains
    params = {
      'Command' => 'namecheap.domains.getList',
      'PageSize' => '100'
    }
    response = make_request(params)
    parse_domain_list(response)
  end

  # Add DNS record to a domain
  def add_dns_record(domain, record_type, host_name, address, ttl = '1800')
    # First, get existing records
    existing_records = get_dns_records(domain)

    # Add the new record
    existing_records << {
      'Type' => record_type,
      'Name' => host_name,
      'Address' => address,
      'TTL' => ttl
    }

    # Set the records
    set_dns_records(domain, existing_records)
  end

  # Remove DNS record from a domain
  def remove_dns_record(domain, record_type, host_name)
    # Get existing records
    existing_records = get_dns_records(domain)

    # Remove the specified record(s)
    updated_records = existing_records.reject do |record|
      record['Type'] == record_type && record['Name'] == host_name
    end

    # Set the updated records
    set_dns_records(domain, updated_records)
  end

  private

  def make_request(extra_params)
    uri = URI.parse(API_URL)
    params = {
      'ApiUser' => @api_user,
      'ApiKey' => @api_key,
      'UserName' => @username,
      'ClientIp' => @client_ip
    }.merge(extra_params)

    response = Net::HTTP.post_form(uri, params)
    Nokogiri::XML(response.body)
  end

  def parse_domain_list(xml_response)
    # Define the namespace
    namespaces = { 'nc' => 'http://api.namecheap.com/xml.response' }
  
    domains = []
    # Use the namespace in the XPath query
    xml_response.xpath('//nc:DomainGetListResult/nc:Domain', namespaces).each do |domain_node|
      domains << {
        'ID' => domain_node['ID'],
        'Name' => domain_node['Name'],
        'User' => domain_node['User'],
        'Created' => domain_node['Created'],
        'Expires' => domain_node['Expires'],
        'IsExpired' => domain_node['IsExpired'],
        'IsLocked' => domain_node['IsLocked'],
        'AutoRenew' => domain_node['AutoRenew'],
        'WhoisGuard' => domain_node['WhoisGuard'],
        'IsPremium' => domain_node['IsPremium'],
        'IsOurDNS' => domain_node['IsOurDNS']
      }
    end
    domains
  end  

  def get_dns_records(domain)
    params = {
      'Command' => 'namecheap.domains.dns.getHosts',
      'SLD' => domain_label(domain),
      'TLD' => domain_extension(domain)
    }
    response = make_request(params)
    parse_dns_records(response)
  end

  def set_dns_records(domain, records)
    params = {
      'Command' => 'namecheap.domains.dns.setHosts',
      'SLD' => domain_label(domain),
      'TLD' => domain_extension(domain)
    }
  
    records.each_with_index do |record, index|
      idx = index + 1
      params["HostName#{idx}"] = record['Name']
      params["RecordType#{idx}"] = record['Type']
      params["Address#{idx}"] = record['Address']
      params["TTL#{idx}"] = record['TTL'] || '1800'
    end
  
    response = make_request(params)
    namespaces = { 'nc' => 'http://api.namecheap.com/xml.response' }
  
    # Check the IsSuccess attribute in the DomainDNSSetHostsResult element
    result_node = response.at_xpath('//nc:DomainDNSSetHostsResult', namespaces)
  
    if result_node && result_node['IsSuccess'] == 'true'
      return true
    else
      # If IsSuccess is not 'true', parse and raise errors
      error_message = parse_errors(response)
      raise StandardError, error_message.empty? ? 'Failed to set DNS records' : error_message
    end
  end  

  def parse_dns_records(xml_response)
    namespaces = { 'nc' => 'http://api.namecheap.com/xml.response' }
    records = []
    xml_response.xpath('//nc:DomainDNSGetHostsResult/nc:host', namespaces).each do |host_node|
      records << {
        'HostId' => host_node['HostId'],
        'Name' => host_node['Name'],
        'Type' => host_node['Type'],
        'Address' => host_node['Address'],
        'MXPref' => host_node['MXPref'],
        'TTL' => host_node['TTL'],
        'AssociatedAppTitle' => host_node['AssociatedAppTitle'],
        'FriendlyName' => host_node['FriendlyName'],
        'IsActive' => host_node['IsActive'],
        'IsDDNSEnabled' => host_node['IsDDNSEnabled']
      }
    end
    records
  end  

  def parse_errors(xml_response)
    # Parse the XML if it's a string; otherwise, assume it's already a Nokogiri document
    doc = xml_response.is_a?(String) ? Nokogiri::XML(xml_response) : xml_response
    
    # Define the namespace with a prefix (e.g., 'nc' for Namecheap)
    namespaces = { 'nc' => 'http://api.namecheap.com/xml.response' }
    
    # Use the namespace prefix in your XPath query
    errors = doc.xpath('//nc:Errors/nc:Error', namespaces).map(&:text)
    
    # Join the error messages with a semicolon and space
    errors.join('; ')
  end

  def domain_label(domain)
    domain_parts = domain.split('.')
    domain_parts[0..-2].join('.')
  end

  def domain_extension(domain)
    domain_parts = domain.split('.')
    domain_parts[-1]
  end
end
