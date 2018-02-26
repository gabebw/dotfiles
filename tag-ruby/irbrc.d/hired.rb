def find_admin
  AdminUser.find_by!(name: 'Gabe Berke-Williams')
end

def find_user
  User.find_by!(email: 'gabebw@gabebw.com')
end
