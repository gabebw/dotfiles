%w(hirb wirble ap pry).each do |gem|
  begin
    require gem
  rescue LoadError
    # ignore
  end
end
