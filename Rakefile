require_relative 'common'
require_relative 'git'

task :init do

  $git_repo = 'git@github.com:SpaceMadness/lunar-unity-plugin.git'
  $git_branch = 'develop'

  $dir_temp = File.expand_path 'temp'
  $dir_repo = "#{$dir_temp}/repo"
  $dir_repo_project = "#{$dir_repo}/Project"

  $dir_tools = resolve_path File.expand_path('tools')
  $dir_tools_copyrighter = resolve_path "#{$dir_tools}/copyrighter"

end

task :clean => [:init] do

  FileUtils.rmtree $dir_temp

end

task :clone_repo => [:init] do

  # cleanup
  FileUtils.rmtree $dir_repo

  # clone
  Git.clone $git_repo, $git_branch, $dir_repo
end

task :resolve_version => [:init] do

  def extract_package_version(dir_project)

    file_version = resolve_path "#{dir_project}/Assets/Plugins/Lunar/Version.cs"
    source = File.read file_version

    source =~ /VERSION\s+=\s+"(\d+\.\d+.\d+b?)"/
    return not_nil $1

  end

  $package_version = extract_package_version(resolve_path $dir_repo_project)
  print_header "Package version: #{$package_version}"

end

desc 'Fixes copyrights versions, etc.'
task :fix_projects => [:init, :resolve_version] do

  Dir.chdir $dir_repo do

    files = []

    # copyrights
    files = files.concat fix_copyrights(resolve_path($dir_repo_project), $dir_tools_copyrighter)

    # push changes
    Git.commit_and_push $dir_repo, $git_branch, files if files.length > 0

  end

end


desc 'Builds package'
task :build => [:clean, :clone_repo, :fix_projects] do

end


