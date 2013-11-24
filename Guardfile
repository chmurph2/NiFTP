group :ruby do
  guard :minitest, all_on_start: false do
    watch(%r{^test/.+_test\.rb$})
    watch('test/test_helper.rb') { "test" }
    watch(%r{^lib/(.+)\.rb$})    { |m| "test/#{m[1]}_test.rb" }
  end
end
