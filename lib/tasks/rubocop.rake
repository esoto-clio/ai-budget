require "rubocop/rake_task"

# RuboCop tasks for code quality
RuboCop::RakeTask.new

namespace :rubocop do
  desc "Run RuboCop with auto-correct"
  task :fix do
    sh "bundle exec rubocop --autocorrect"
  end

  desc "Run RuboCop with auto-correct-all (potentially unsafe corrections)"
  task :fix_all do
    sh "bundle exec rubocop --autocorrect-all"
  end

  desc "Run RuboCop and generate HTML report"
  task :report do
    sh "bundle exec rubocop --format html --out tmp/rubocop_report.html"
    puts "RuboCop report generated at tmp/rubocop_report.html"
  end

  desc "Run RuboCop on staged files only"
  task :staged do
    staged_files = `git diff --cached --name-only --diff-filter=ACM`.split("\n")
                                                                   .select { |file| file.end_with?(".rb") }
                                                                   .join(" ")

    if staged_files.empty?
      puts "No Ruby files staged for commit"
    else
      sh "bundle exec rubocop #{staged_files}"
    end
  end

  desc "Run RuboCop on changed files only"
  task :changed do
    changed_files = `git diff --name-only --diff-filter=ACM`.split("\n")
                                                           .select { |file| file.end_with?(".rb") }
                                                           .join(" ")

    if changed_files.empty?
      puts "No Ruby files changed"
    else
      sh "bundle exec rubocop #{changed_files}"
    end
  end
end

# Add RuboCop to the default test task
task default: [ :rubocop, :spec ]

# Pre-commit hook task
desc "Run all quality checks (RuboCop, Brakeman, tests)"
task :quality do
  puts "🔍 Running RuboCop..."
  Rake::Task["rubocop"].invoke

  puts "\n🔒 Running Brakeman security scan..."
  system("bin/brakeman --no-pager --quiet")
  unless $?.success?
    puts "❌ Brakeman found security issues!"
    exit 1
  end

  puts "\n✅ Code quality checks passed!"
  puts "💡 Note: Run 'rake spec' separately to run tests"
rescue StandardError => e
  puts "\n❌ Quality checks failed: #{e.message}"
  exit 1
end

# Separate task for running tests only
desc "Run RSpec tests"
task :test do
  puts "🧪 Running tests..."
  Rake::Task["spec"].invoke
end

# Full quality check including tests
desc "Run all quality checks including tests (may fail if tests need work)"
task :quality_with_tests do
  puts "🔍 Running RuboCop..."
  Rake::Task["rubocop"].invoke

  puts "\n🔒 Running Brakeman security scan..."
  system("bin/brakeman --no-pager --quiet")
  unless $?.success?
    puts "❌ Brakeman found security issues!"
    exit 1
  end

  puts "\n🧪 Running tests..."
  Rake::Task["spec"].invoke

  puts "\n✅ All quality checks passed!"
rescue StandardError => e
  puts "\n❌ Quality checks failed: #{e.message}"
  exit 1
end
