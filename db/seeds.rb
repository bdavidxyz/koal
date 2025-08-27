# Load fixtures from test/fixtures directory
require 'active_record/fixtures'

if User.count == 0
  puts "Loading fixtures..."

  # Load all fixtures from test/fixtures
  ActiveRecord::FixtureSet.create_fixtures('test/fixtures', [
    'users',
    'rabarber_roles',
    'rabarber_roles_roleables',
    'blogtags',
    'blogposts',
    'blogtag_blogposts'
  ])

  puts "Fixtures loaded successfully!"
else
  puts "Already sth in the DB, skipped seed"
end
