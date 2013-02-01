class User < Jooxe::Model
  User.fields = {:table => [:account_name,:given_name,:mail]}
end
