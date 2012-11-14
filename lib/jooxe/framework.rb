Dir.glob('lib/jooxe/middleware/*.rb') do |f|
  require f
end
    
Dir.glob('lib/jooxe/core/*.rb') do |f|
  require f
end


Dir.glob('lib/jooxe/*.rb') do |f|
  require f
end
