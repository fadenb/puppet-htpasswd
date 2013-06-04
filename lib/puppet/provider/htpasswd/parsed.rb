require 'puppet/provider/parsedfile'
htpasswd_file = "/etc/httpd/conf/htpasswd"

Puppet::Type.type(:htpasswd).provide(
  :parsed,
  :parent => Puppet::Provider::ParsedFile,
  :default_target => htpasswd_file,
  :filetype => :flat
) do

  desc "htpasswd provider that uses the ParsedFile class"

  text_line :blank, :match => /^\s*$/
  text_line :comment, :match => /^#/
  record_line :parsed, :fields => %w{username cryptpasswd},
    :separator => ':',
    :joiner    => ':'

  def self.prefetch_hook(records)
    name = nil
    res = records.each do |record|
        record[:name] = record[:username]
    end.reject { |record| record[:skip] }
  end
end
