require 'date'
require 'open-uri'

REMOTE_FILE = 'http://s3.amazonaws.com/tcmg412-fall2016/http_access_log'
MY_FILE = 'http_access_log'
LOG_FILES = 'logs/'

i = 0
by_month = {}
files = {}
sums = {}
errors = []

print "downloading"
download open(REMOTE_FILE)
IO.copy_stream(download, MY_FILE)
puts "downloaded" 

File.foreach(MY_FILE) do |line|
  
  regex = /.* \[(.*) .*\] "([A-Z]{3,4}) (.*) .*" (\d{3}) .*/.match(line)
  
  if !regex then 
          errors.push(line)
          next
  end
  
  


