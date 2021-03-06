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
  
  re_date = Date.strptime(regex[1], '%d/%b/%Y:%H:%M:%S')
  year_month = re_date.strftime('%Y-%m')
  http_request = regex[2]
  file_id = regex[3]
  file_code = regex[4]
  
  files[file_id] = (if files[file_id] then files[file_name]+=1 else 1 end)
  
  sums[file_code] = (if sums[file_code] then sums[file_code]+=1 else 1 end)
  
  unless by_month[year_month] then by_month[year_month] = [] end
  
  by_month[year_month].push(line) 
  
end
puts "\n\n"

sort_files = files.sort_by { |k, v| -v }

main_total = 0

Dir.mkdir(LOG_FILES) unless File.exists? (LOG_FILES)

by_month.each do |key, arr| 
        main_total += arr.count
        file_id = LOG_FILES + key + '.log'
        
        File.open(file_id, "w+") do |f|
            f.puts(arr) 
        end  
        puts " Creating new file: #{file_id} (#{arr.count} entries)"
end
      
counts_3xx = 0
counts_4xx = 0
counts_5xx = 0
counts.each do |code, count| 
      if code [0] == "3" then counts_3xx += count end
      if code [0] == "4" then counts_4xx += count end
      if code [0] == "5" then counts_5xx += count end
end          
uns_per = (counts_4xx.to_f / main_total.to_f * 100).to_i 
red_per = (counts_3xx.to_f / main_total.to_f * 100).to_i

File.open("error.log", "w+") do |f| 
        f.puts(errors)
end

puts "\n\n\n"
puts "--- STATS ---"
puts "Total requests: #{main_total}"
puts "Monthly requests:" by_month.each do |mon, lines|
      puts "  #{mon}: #{lines.count}"
end 
puts "Average of monthly requests: #{main_total / by_month.count}"
puts "Most requested file: #{sort_files[0]}"
puts "Least requested file: #{sort_files[sort_files.count-1]}"
puts "Percent of errors: #{uns_per}% (#{counts_4xx} total)"
puts "Percent of redirects: #{red_per}% (#{counts_3xx} total)"

puts "\n\n--- ERRORS ---"
puts "Encountered parsing errors on #{errors.count} lines."
puts " Output written to error.log \n\n"      

        
          
             


