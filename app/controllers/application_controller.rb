class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  # before_action :add_allow_credentials_headers
  after_action :cors_set_access_control_headers

  after_action :unset_current_user

  def route_options
    cors_preflight_check
  end

  def cors_set_access_control_headers
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, PATCH, DELETE, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    response.headers['Access-Control-Max-Age'] = "1728000"
  end

  def cors_preflight_check
    if request.method == 'OPTIONS'
      request.headers['Access-Control-Allow-Origin'] = '*'
      request.headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, PATCH, DELETE, OPTIONS'
      request.headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Token'
      request.headers['Access-Control-Max-Age'] = '1728000'
      render :text => '', :content_type => 'text/plain'
    end
  end

  def log_request
    begin
      unless request.method == 'OPTIONS'
        @request = Request.create(
            http_method: request.method,
            url: request.path,
            user_agent: request.user_agent,
            ip_address: request.remote_ip,
            post_params: Oj.dump(filtered_request_params),
            get_params: Oj.dump(request.query_parameters.as_json),
            api_key: api_key_from_header,
            headers: Oj.dump(request_headers.as_json),
            response_status: response.status,
            response_body: response.body,
            response_headers: Oj.dump(response.headers.as_json),
            success: response.status < 400 ? true : false
        )
        response.headers["Zagu-Request-Id"] = @request.id
      end
    rescue
    #TODO: Fazer o rescue
    end
  end

  def request_headers
    http_envs = {}.tap do |envs|
      request.headers.each do |key, value|
        envs[key] = value if key.downcase.starts_with?('http')
      end
    end
    # return http_request_header_keys
  end

  # def add_allow_credentials_headers
  #   # https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS#section_5
  #   #
  #   # Because we want our front-end to send cookies to allow the API to be authenticated
  #   # (using 'withCredentials' in the XMLHttpRequest), we need to add some headers so
  #   # the browser will not reject the response
  #   response.headers['Access-Control-Allow-Origin'] = request.headers['Origin'] || '*'
  #   response.headers['Access-Control-Allow-Credentials'] = 'true'
  #   response.headers['Access-Control-Allow-Methods'] = 'DELETE, PATCH, *'
  # end

  def index
    render text: 'A documentação da API está disponível no site: http://docestagio.zagu.com.br/'
  end

  # def options
  #   head :status => 200, :'Access-Control-Allow-Headers' => 'accept, content-type, authorization'
  # end

  def api_key_from_header
    bearer_pattern = /^Bearer /
    basic_pattern = /^Basic /
    auth_header = request.env['HTTP_AUTHORIZATION']

    if auth_header
      if auth_header.match(bearer_pattern)
        return auth_header.gsub(bearer_pattern, '')
      else
        token = Base64.decode64(auth_header.gsub(basic_pattern, ''))
        return token.slice(0..(token.index(':'))).gsub(':', '') if token.include?(':')
      end
    end
  end

  def authenticate
    # bearer_pattern = /^Bearer /
    # basic_pattern = /^Basic /
    # auth_header = request.env['HTTP_AUTHORIZATION']
    #
    # if auth_header
    #   if auth_header.match(bearer_pattern)
    #     token = auth_header.gsub(bearer_pattern, '')
    #   else
    #     token = Base64.decode64(auth_header.gsub(basic_pattern, ''))
    #     token = token.slice(0..(token.index(':'))).gsub(':', '') if token.include?(':')
    #   end
    # end

    token = api_key_from_header
    # token = header.gsub(pattern, '') if header && header.match(pattern)

    @current_user_token = UserToken.find_by_token(token)

    if @current_user_token
      if @current_user_token.expiry_at && @current_user_token.expiry_at < Time.now
        @current_user_token.destroy
        render json: { message: 'This key has expired.' }, status: :unauthorized
        return false
      else
        # @current_user_token.update_attributes(
        #     expiry_at: Time.now + UserToken::TTL,
        #     last_request_at: Time.now,
        #     last_request_ip: request.env['REMOTE_ADDR']
        # )

        @current_user = User.find(@current_user_token.user_id)

        unless @current_user
          render json: { message: 'Invalid secret key.' }, status: :unauthorized
          return false
        end
      end

    else
      render json: { message: 'Invalid secret key.' }, status: :unauthorized
      return false
    end
  end

  def set_current_user
    # User.current needs to use Thread.current!
    User.current = @current_user
  end

  def unset_current_user
    # User.current needs to use Thread.current!
    User.current = nil
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
    @current_user = @current_user_session.user if @current_user_session
  end

  def require_user_session
    unless current_user_session
      # flash[:notice] = "Por favor, autentique-se primeiro."

      redirect_to :controller => "user_sessions", :action => "index"
      return false
    end
  end

  def filtered_request_params
    ret = request.request_parameters.as_json

    ret["number"] = 'FILTERED' if ret.key?("number")
    ret["password"] = 'FILTERED' if ret.key?("password")
    ret["password_confirmation"] = 'FILTERED' if ret.key?("password_confirmation")

    ret
  end

end
