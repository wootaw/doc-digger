module DocDigger

  def self.scan(root, files='*')
    all = []
    Dir[File.join(root, "**/#{files}")].each do |fn|
      dp = DocDigger::FileParser.new(fn)
      docs = dp.results
      if docs.length == 0
        print ".".blue
      else
        all += docs
        docs.each do |doc|
          print "#{'*' * doc[:resources].length}".green
        end
      end
    end
    all
  end

  def self.scan_current_branch(root)
    git = Git.open(root)

    current_branch = git.current_branch

    lastest_commit = git.log.first

    files = lastest_commit.diff(git.log[3].sha).stats[:files]
    # ap files
  end
end