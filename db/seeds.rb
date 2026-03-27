# Seed file with actual ActiveRecord hardcoded insertions

if User.count == 0
  puts "Seeding database..."

  # Create roles explicitly (these are needed before assigning to users)
  # The member role is automatically assigned via after_create callback on User
  # So we just need to create the superadmin role
  superadmin_role = Rabarber::Role.create!(name: 'superadmin')
  member_role = Rabarber::Role.create!(name: 'member')

  # Create users
  jane = User.create!(
    email: 'jane@hotmail.com',
    slug: 'jane-slug',
    name: 'jane',
    password: 'Secret1*3*5*',
    password_confirmation: 'Secret1*3*5*',
    verified: true
  )

  alicia = User.create!(
    email: 'alicia@example.com',
    slug: 'alicia-slug',
    name: 'alicia',
    password: 'Secret1*3*5*',
    password_confirmation: 'Secret1*3*5*',
    verified: true
  )

  # Assign superadmin role to jane (she already has :member from after_create callback)
  jane.assign_roles(:superadmin)

  # Alicia already has :member from after_create callback

  # Create blogtags
  alpha = Blogtag.create!(name: 'Alpha')
  beta = Blogtag.create!(name: 'Beta')

  # Create blogposts (slug will be auto-generated via after_create callback)
  first_blogpost = Blogpost.create!(
    title: 'The Future of Web Development',
    kontent: 'Web development continues to evolve at a rapid pace. With the rise of new frameworks and tools, developers are finding more efficient ways to build robust applications. The focus on performance, accessibility, and user experience has never been more important.',
    chapo: 'Exploring the latest trends and technologies shaping the future of web development',
    published_at: 1.day.ago
  )

  second_blogpost = Blogpost.create!(
    title: 'Understanding Modern Authentication',
    kontent: 'Authentication is a critical aspect of any application\'s security. Modern authentication methods have moved beyond simple username and password combinations. We now have OAuth, JWT, and other sophisticated methods to ensure secure access to our applications.',
    chapo: 'A comprehensive guide to implementing secure authentication in modern applications',
    published_at: 2.days.ago
  )

  # Create blogtag-blogpost associations
  BlogtagBlogpost.create!(blogpost: first_blogpost, blogtag: alpha)
  BlogtagBlogpost.create!(blogpost: first_blogpost, blogtag: beta)
  BlogtagBlogpost.create!(blogpost: second_blogpost, blogtag: beta)

  puts "Seeding completed successfully!"
else
  puts "Already sth in the DB, skipped seed"
end
