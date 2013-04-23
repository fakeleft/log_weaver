require 'bundler'
require 'rake/clean'

require 'rspec/core/rake_task'

require 'cucumber'
require 'cucumber/rake/task'

include Rake::DSL

Bundler::GemHelper.install_tasks


RSpec::Core::RakeTask.new do |t|
  # Put spec opts in a file named .rspec in root
end


CUKE_RESULTS = 'results.html'
CLEAN << CUKE_RESULTS
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format html -o #{CUKE_RESULTS} --format pretty --no-source -x"
  t.fork = false
end

desc "Generate RDoc"
task :doc => ['doc:generate']

namespace :doc do
  project_root = File.expand_path(File.join(File.dirname(__FILE__), '.'))
  doc_destination = File.join(project_root, 'doc', 'rdoc')

  begin
    require 'yard'
    require 'yard/rake/yardoc_task'

    YARD::Rake::YardocTask.new(:generate) do |yt|
      yt.files   = Dir.glob(File.join(project_root, 'lib', '**', '*.rb')) +
          [ File.join(project_root, 'README.md') ]
      yt.options = ['--output-dir', doc_destination, '--readme', 'README.md']
    end
  rescue LoadError
    desc "Generate YARD Documentation"
    task :generate do
      abort "Please install the YARD gem to generate rdoc."
    end
  end

  desc "Remove generated documenation"
  task :clean do
    rm_r doc_destination if File.exists?(doc_destination)
  end

end

task :default => [:spec,:features]

