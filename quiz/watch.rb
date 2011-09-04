watch('./.*.js') do |match|
  puts "Updating #{match}..."
  #system("coffee -c #{match}")
  system("jasmine-node --coffee ./spec")
end
