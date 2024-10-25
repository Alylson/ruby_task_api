module Authenticable
    SECRET_KEY = ENV['SECRET_KEY_BASE']
  
    def authenticate_request!
        token = request.headers['Authorization']
        if token.present?
          begin
            decoded_token = JWT.decode(token.split(' ').last, SECRET_KEY, true, algorithm: 'HS256')
            @current_user_id = decoded_token[0]['user_id']
          rescue JWT::DecodeError
            render json: { error: 'Invalid token' }, status: :unauthorized
          end
        else
          render json: { error: 'Token not provided' }, status: :unauthorized
        end
    end
end
  