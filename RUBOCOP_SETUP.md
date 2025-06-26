# 🎯 RuboCop Setup & Code Quality Guide

## Overview

This Rails 8 Budget Tracker project uses **RuboCop** for code quality, style consistency, and best practices enforcement. The setup includes Rails Omakase configuration with project-specific customizations.

## 🛠️ Installation & Configuration

### Gems Included
```ruby
# Gemfile
gem "rubocop-rails-omakase", require: false  # Rails Omakase styling
gem "rubocop-rspec", require: false          # RSpec-specific rules
```

### Configuration Files
- **`.rubocop.yml`** - Main configuration with project customizations
- **`.vscode/settings.json`** - VS Code integration
- **`.git/hooks/pre-commit`** - Git pre-commit hook
- **`lib/tasks/rubocop.rake`** - Custom Rake tasks

## 🎨 Configuration Highlights

### Code Style Preferences
- **Line length**: 120 characters (increased from default 80)
- **String literals**: Double quotes preferred
- **Trailing commas**: Required in multiline arrays/hashes
- **Method length**: Up to 15 lines (relaxed for controllers)
- **Class length**: Up to 150 lines (relaxed for models/controllers)

### Project-Specific Rules
```yaml
# Disabled rules for practical development
Style/Documentation: false          # No class documentation required
Style/FrozenStringLiteralComment: false  # No frozen string literals
Rails/I18nLocaleTexts: false       # Not using I18n

# Relaxed metrics for Rails patterns
Metrics/MethodLength:
  Max: 15
  Exclude: ['app/controllers/**/*', 'spec/**/*']

Metrics/AbcSize:
  Max: 20
  Exclude: ['app/controllers/**/*', 'spec/**/*']
```

## 🚀 Usage Commands

### Basic Commands
```bash
# Run RuboCop on all files
bundle exec rubocop

# Auto-correct safe issues
bundle exec rubocop --autocorrect

# Auto-correct all issues (including unsafe)
bundle exec rubocop --autocorrect-all

# Check specific files
bundle exec rubocop app/models/user.rb
```

### Custom Rake Tasks
```bash
# Quick auto-correct
rake rubocop:fix

# Auto-correct all (including unsafe)
rake rubocop:fix_all

# Generate HTML report
rake rubocop:report

# Check only staged files
rake rubocop:staged

# Check only changed files
rake rubocop:changed

# Run all quality checks
rake quality
```

### Development Workflow
```bash
# Before committing (runs automatically via pre-commit hook)
rake rubocop:staged

# During development
rake rubocop:changed

# Full project check
rake rubocop
```

## 🔧 IDE Integration

### VS Code Setup
The project includes `.vscode/settings.json` with:
- **Auto-format on save** using RuboCop
- **Real-time linting** with error highlighting
- **Proper indentation** and rulers
- **File associations** for Ruby files

### Recommended Extensions
- `misogi.ruby-rubocop` - RuboCop integration
- `rebornix.ruby` - Ruby language support
- `kaiwood.endwise` - Auto-close Ruby blocks

## 🎯 Git Integration

### Pre-commit Hook
Automatically runs RuboCop on staged files before each commit:
```bash
# Located at .git/hooks/pre-commit
🚀 Running pre-commit checks...
🔍 Running RuboCop on staged Ruby files...
✅ RuboCop checks passed!
```

### Skip Pre-commit (Not Recommended)
```bash
git commit --no-verify -m "Skip quality checks"
```

## 🏗️ CI/CD Integration

### GitHub Actions
The `.github/workflows/ci.yml` includes:
- **RuboCop job** - Style and quality checks
- **Security job** - Brakeman security scan
- **Test job** - RSpec test suite
- **Quality gate** - Requires all checks to pass

### CI Commands
```yaml
# RuboCop with parallel processing
bundle exec rubocop --parallel

# Security scan
bundle exec brakeman --exit-on-warn --no-pager
```

## 📊 Quality Metrics

### Current Status
- ✅ **96 files** inspected
- ✅ **0 offenses** detected
- ✅ **100% compliance** with style guide

### Excluded Files
- `vendor/**/*` - Third-party code
- `node_modules/**/*` - JavaScript dependencies
- `tmp/**/*` - Temporary files
- `log/**/*` - Log files
- `db/migrate/*.rb` - Database migrations
- `db/schema.rb` - Generated schema

## 🛡️ Security Integration

### Brakeman Integration
RuboCop works alongside Brakeman for comprehensive code quality:
```bash
# Run both tools
rake quality

# Individual tools
bundle exec rubocop      # Style & best practices
bundle exec brakeman     # Security vulnerabilities
```

## 🔍 Common Issues & Solutions

### 1. Line Too Long
```ruby
# ❌ Bad
some_very_long_method_call_that_exceeds_the_line_length_limit_and_makes_code_hard_to_read(param1, param2, param3)

# ✅ Good
some_very_long_method_call_that_exceeds_the_line_length_limit_and_makes_code_hard_to_read(
  param1,
  param2,
  param3,
)
```

### 2. Missing Trailing Commas
```ruby
# ❌ Bad
hash = {
  key1: "value1",
  key2: "value2"
}

# ✅ Good
hash = {
  key1: "value1",
  key2: "value2",
}
```

### 3. String Literals
```ruby
# ❌ Bad (single quotes)
message = 'Hello world'

# ✅ Good (double quotes)
message = "Hello world"
```

### 4. Method Length
```ruby
# ❌ Bad (too long)
def complex_method
  # 20+ lines of code
end

# ✅ Good (extract methods)
def complex_method
  step_one
  step_two
  step_three
end

private

def step_one
  # Implementation
end
```

## 🎨 Customization

### Adding Project Rules
Edit `.rubocop.yml`:
```yaml
# Add new rule
Style/YourCustomRule:
  Enabled: true
  EnforcedStyle: your_preference

# Disable rule for specific files
Metrics/ClassLength:
  Exclude:
    - 'app/models/large_model.rb'
```

### Per-File Overrides
```ruby
# At the top of a specific file
# rubocop:disable Style/Documentation
class LegacyClass
  # No documentation required for this class
end
# rubocop:enable Style/Documentation
```

### Inline Disables
```ruby
def legacy_method
  some_code # rubocop:disable Style/SomeRule
end
```

## 📈 Best Practices

### 1. Run Before Committing
```bash
# Always run before committing
rake rubocop:staged
```

### 2. Fix Issues Incrementally
```bash
# Fix safe issues first
rake rubocop:fix

# Review unsafe fixes manually
rake rubocop:fix_all
```

### 3. Use in Development
```bash
# Check your changes
rake rubocop:changed

# Generate reports for review
rake rubocop:report
```

### 4. Team Workflow
- **New team members**: Run `rake rubocop` to understand style
- **Code reviews**: RuboCop runs automatically in CI
- **Refactoring**: Use RuboCop to maintain consistency

## 🚨 Troubleshooting

### RuboCop Not Running
```bash
# Check installation
bundle exec rubocop --version

# Reinstall if needed
bundle install
```

### Configuration Errors
```bash
# Validate configuration
bundle exec rubocop --debug

# Check for syntax errors in .rubocop.yml
```

### Pre-commit Hook Issues
```bash
# Make hook executable
chmod +x .git/hooks/pre-commit

# Test hook manually
.git/hooks/pre-commit
```

### VS Code Integration
```bash
# Install required extensions
code --install-extension misogi.ruby-rubocop
code --install-extension rebornix.ruby
```

## 📚 Resources

### Documentation
- [RuboCop Official Docs](https://docs.rubocop.org/)
- [Rails Omakase Style Guide](https://github.com/rails/rubocop-rails-omakase)
- [RuboCop RSpec Rules](https://docs.rubocop.org/rubocop-rspec/)

### Configuration References
- [RuboCop Configuration](https://docs.rubocop.org/rubocop/configuration.html)
- [Rails Cops](https://docs.rubocop.org/rubocop-rails/)
- [RSpec Cops](https://docs.rubocop.org/rubocop-rspec/)

## 🎉 Benefits

### Code Quality
- **Consistent style** across the entire codebase
- **Best practices** enforcement
- **Early bug detection** through static analysis

### Team Productivity
- **Reduced code review** time on style issues
- **Faster onboarding** with clear style guidelines
- **Automated fixes** for common issues

### Maintainability
- **Readable code** with consistent formatting
- **Reduced complexity** through metric enforcement
- **Security awareness** through integrated tools

This RuboCop setup provides a solid foundation for maintaining high code quality while being practical for Rails development. The configuration balances strict style enforcement with development productivity. 