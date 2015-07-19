require_relative 'common.rb'

class Git

  def self.clone(repo, branch, dest_dir)

    exec_shell("git clone #{repo} --depth 1 -b #{branch} #{dest_dir}", "Can't clone repo: #{repo}")

    Dir.chdir dest_dir do
      exec_shell('git submodule init', "Can't init git submodules")
      exec_shell('git submodule update', "Can't update git submodules")
    end
  end

  def self.commit_and_push(repo, branch, files)

    Dir.chdir repo do
      files.each { |file|
        exec_shell %(git add "#{file}"), "Can't add file: #{file}"
      }
      exec_shell %(git commit -m "Updated SDK files by builder" --author "GH-automator <placeplayhood@gmail.com>"), "Can't commit to git"
      exec_shell %(git push origin #{branch}), "Can't push to git"
    end

  end

end