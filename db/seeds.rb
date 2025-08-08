# Users seeds

# Only seed if there are no users in the database
if User.count == 0
  puts "Seeding users..."

  a_user = User.create!(
  email: 'a@user.com',
  password: 'SecurePassword123!',
  verified: true,
)
a_user.assign_roles(:superadmin)

b_user = User.create!(
  email: 'b@user.com',
  password: 'SecurePassword123!',
  verified: true,
)

c_user = User.create!(
  email: 'c@user.com',
  password: 'SecurePassword123!',
  verified: false,
)
c_user.assign_roles(:superadmin)

d_user = User.create!(
  email: 'd@user.com',
  password: 'SecurePassword123!',
  verified: true,
)

e_user = User.create!(
  email: 'e@user.com',
  password: 'SecurePassword123!',
  verified: true,
)

f_user = User.create!(
  email: 'f@user.com',
  password: 'SecurePassword123!',
  verified: false,
)

g_user = User.create!(
  email: 'g@user.com',
  password: 'SecurePassword123!',
  verified: true,
)

h_user = User.create!(
  email: 'h@user.com',
  password: 'SecurePassword123!',
  verified: false,
)

i_user = User.create!(
  email: 'i@user.com',
  password: 'SecurePassword123!',
  verified: true,
)

j_user = User.create!(
  email: 'j@user.com',
  password: 'SecurePassword123!',
  verified: true,
)

k_user = User.create!(
  email: 'k@user.com',
  password: 'SecurePassword123!',
  verified: false,
)

l_user = User.create!(
  email: 'l@user.com',
  password: 'SecurePassword123!',
  verified: true,
)

m_user = User.create!(
  email: 'm@user.com',
  password: 'SecurePassword123!',
  verified: false,
)

n_user = User.create!(
  email: 'n@user.com',
  password: 'SecurePassword123!',
  verified: true,
)

o_user = User.create!(
  email: 'o@user.com',
  password: 'SecurePassword123!',
  verified: true,
)

  puts "Users seeded successfully!"
else
  puts "Users already exist in database. Skipping user seeds."
end
