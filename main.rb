class ApiApp < Grape::API
  version 'v0', using: :path
  mount ApiV0
end

