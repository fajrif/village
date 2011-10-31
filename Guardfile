# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', :version => 2, :all_after_pass => false do
  watch(%r{^app/.+\.(rb|erb|haml)$})       { "spec" }
  watch(%r{^spec/.+\.(rb|erb|haml|markdown|md|mkd|rdoc|yml)$})  { "spec" }
  watch(%r{^lib/.+\.rb$})                  { "spec" }
  watch('spec/spec_helper.rb')             { "spec" }
end
