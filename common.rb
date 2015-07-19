require_relative 'tools/copyrighter/copyright'

# check condition and raise exception
def print_header(message)
  puts message
end

############################################################

# check condition and raise exception
def fail_script(message)
  raise "Build failed! #{message}"
end

############################################################

# check condition and raise exception
def fail_script_unless(condition, message)
  fail_script message unless condition
end

############################################################

# check if file exists and raise exception
def fail_script_unless_file_exists(path)
  fail_script_unless path != nil && (File.directory?(path) || File.exists?(path)), "File doesn't exist: '#{path}'"
end

############################################################

def not_nil(value)
  fail_script_unless value != nil, 'Value is nil'
  return value
end

############################################################

# checks if path exists and returns it
def resolve_path(path)
  fail_script_unless_file_exists path
  return path
end

############################################################

# execute shell command and raise exception if fails
def exec_shell(command, error_message, options = {})
  puts "Running command: #{command}" unless options[:silent] == true
  result = `#{command}`
  if options[:dont_fail_on_error] == true
    puts error_message unless $?.success?
  else
    fail_script_unless($?.success?, "#{error_message}\nShell failed: #{command}\n#{result}")
  end

  return result
end

def fix_version(version)

  print_header 'Fixing versions...'

  modified_files = []
  return modified_files

end

def fix_copyrights(dir_project)

  print_header 'Fixing copyright...'

  modified_files = []

  Dir["#{dir_project}/**/*.cs"].each do |file|
    modified_files.push file if fix_copyright file
  end

  return modified_files

end

def fix_copyright(file)

  old_text = File.read file

  copyright = Copyright.new old_text
  copyright.set_param 'date.year', Time.now.year.to_s
  copyright.set_param 'file.name.ext', File.basename(file)
  copyright.set_param 'file.name', File.basename(file, '.*')

  new_text = copyright.process

  if new_text != old_text
    File.write file, new_text
    return true
  end

  return false
end