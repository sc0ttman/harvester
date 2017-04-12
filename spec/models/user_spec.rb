require 'rails_helper'

RSpec.describe User, type: :model do
  let (:employee_params) {{
    email: "scott@example.com",
    is_admin: true,
    first_name: "Scott",
    last_name: "L",
    is_contractor: false,
    organization_id: 1
  }}
  let (:employee) { User.new employee_params }

  context '#full_name' do
    it 'concats first and last name' do
      expect(employee.full_name).to eq 'Scott L'
    end
  end

end
