## an ext for active_record to delegate column to another class

### Example
```ruby
class User
  # schema
  # id, integer
  # mobile_phone, string

  has_one :extend_user
end

class ExtendUser
  # schema
  # id, integer
  # user_id, integer

  belongs_to :user
  delegate_column :mobile_phone, to: :user
end

ExtendUser.where(mobile_phone: '123456').first
```
