require 'coveralls'
Coveralls.wear!

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.filter_run_including focus: true
  config.run_all_when_everything_filtered = true
end

require 'active_record'
if ActiveRecord::Base.respond_to?(:raise_in_transactional_callbacks=)
  ActiveRecord::Base.raise_in_transactional_callbacks = true
end
if ActiveRecord.version > Gem::Version.new('6.2')
  ActiveRecord.use_yaml_unsafe_load = true
else
  ActiveRecord::Base.use_yaml_unsafe_load = true
end
