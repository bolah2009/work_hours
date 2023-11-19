roles = [
  {
    name: 'admin',
    privileges: {
      users: {
        can_create: true,
        can_read: true,
        can_update: true,
        can_delete: true
      },
      organizations: {
        can_create: true,
        can_read: true,
        can_update: true,
        can_delete: true
      }
    }
  },
  {
    name: 'member',
    privileges: {
      users: {
        can_create: false,
        can_read: true,
        can_update: false,
        can_delete: false
      },
      organizations: {
        can_create: false,
        can_read: true,
        can_update: false,
        can_delete: false
      }
    }
  },
  {
    name: 'owner',
    privileges: {
      users: {
        can_create: true,
        can_read: true,
        can_update: false,
        can_delete: true
      },
      organizations: {
        can_create: true,
        can_read: true,
        can_update: true,
        can_delete: true
      }
    }
  }
]

roles.each do |role_data|
  role = Role.find_or_initialize_by(name: role_data[:name])
  role.update(privileges: role_data[:privileges])
end
