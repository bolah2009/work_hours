# Load seeds for roles
load Rails.root.join('db/seeds/roles.rb')

password = 'password'

p 'Creating owner user'
owner_user = User.find_or_initialize_by(email: 'john@example.com')
owner_user.update(password:, name: Faker::Name.unique.name) unless owner_user.valid?

p 'Creating organizations'
Organization.find_or_create_by!(name: 'Factorial HR')
4.times do
  Organization.create(name: Faker::Company.unique.name)
end

Organization.all.each_with_index do |organization, org_index|
  p "Creating users with metrics for #{(1 + org_index).ordinalize} organization: #{organization.name}"

  owner_role = Role.find_or_create_by!(name: 'owner')
  owner_user.memberships.create(role: owner_role, organization:)

  admin_role = Role.find_or_create_by!(name: 'admin')
  (1..3).each do |index|
    admin_user = User.find_or_initialize_by(email: "admin_user#{index}@example.com")
    admin_user.update(password:, name: Faker::Name.unique.name) unless admin_user.valid?
    admin_user.memberships.create(role: admin_role, organization:)
  end

  member_role = Role.find_or_create_by!(name: 'member')
  (1..5).each do |index|
    member_user = User.find_or_initialize_by(email: "member_user#{index}@example.com")
    member_user.update(password:, name: Faker::Name.unique.name) unless member_user.valid?
    member_user.memberships.create(role: member_role, organization:)
  end

  # Define the date range for seeding 1 months worth metrics
  start_date = Time.zone.today - 1.month
  end_date = Time.zone.today

  # Create metrics for all users in the organization for workdays within the date range (1 months)
  organization.memberships.each do |user_organization|
    current_date = start_date
    while current_date <= end_date
      # Check if it's a workday (Monday to Friday)
      if (1..5).cover?(current_date.wday)
        # Define random workday start and end hours
        workday_start_hour = [8, 10].freeze.sample # Random start hour between 8 AM and 10 AM
        workday_end_hour = [16, 18].freeze.sample # Random end hour between 4 PM and 5 PM

        start_time = current_date.to_time.change(hour: workday_start_hour,  min: (0..59).to_a.sample)
        end_time = current_date.to_time.change(hour: workday_end_hour, min: (0..59).to_a.sample)
        organization.metrics
                    .where(date: current_date, user_id: user_organization.user_id)
                    .find_or_create_by!(
                      start_time:,
                      end_time:
                    )
      end
      current_date += 1.day # Move to the next day
    end
  end
end
