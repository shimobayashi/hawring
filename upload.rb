#!/usr/bin/ruby
require 'cgi'
require 'digest/md5'

begin
  cgi = CGI.new

  file = cgi.params['file'][0]
  ext = File.extname(file.original_filename)
  body = file.read
  basename = Digest::MD5.hexdigest(body)
  filename = basename + ext

  raise 'too large file' if body.size > 20000000
  raise 'not allowed ext' unless ['.mp3', '.aac', '.wav', '.ogg', '.m4a'].include?(ext)

  open(Dir.getwd + '/music/' + filename, 'w') do |fh|
    fh.binmode
    fh.write body
  end
  open(Dir.getwd + '/current.json', 'w') do |fh|
    fh.write "{\"filename\":\"#{filename}\"}\n"
  end

  print cgi.header("status" => "OK")
  print 'ok'
rescue Exception => e
  print cgi.header("status" => "BAD_REQUEST")
  print e.to_s
end
