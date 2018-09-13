def sign_in
  post users_url, params: {user: {name: 'the user'}}
end
