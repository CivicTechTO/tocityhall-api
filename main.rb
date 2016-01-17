class ApiApp < Grape::API

  get do
    # Redirect to current version
    redirect 'v0'
  end

  version 'v0', using: :path
  mount ApiV0
end

