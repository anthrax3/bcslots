module SuperSimpleAuth
  def generate_new_cookie_id args
    raise 'Please implement generate_new_cookie_id . It should return a new cookie id.'
  end
  def get_cookie_state  args
    raise 'Please implement get_cookie_state if you would like to use the super_simple_auth_index
    and super_simple_auth_show shortcuts. Otherwise, call super_simple_auth directly. get_cookie_state
    should return a truthy value if there is state associated with the id, and a falsy value otherwise.'
  end
  def get_param_state  args
    raise 'Please implement get_param_state if you would like to use the super_simple_auth_index
    and super_simple_auth_show shortcuts. Otherwise, call super_simple_auth directly. get_param_state
    should return a truthy value if there is state associated with the id, and a falsy value otherwise.'
  end
  def render_show args
    raise 'For API clarity, please implement render_show, even if it\'s just with an empty method.'
  end
  def cookie_id_name args
    'id'
  end
  def param_id_name args
    'id'
  end
  def index_and_no_cookie_id args
    generate_new_cookie_id_set_cookie_and_redirect_to_show args
  end
  def index_and_cookie_id_with_valid_state args
    redirect_to_show args
  end
  def index_and_cookie_id_with_invalid_state args
    generate_new_cookie_id_set_cookie_and_redirect_to_show args
  end
  def show_and_cookie_id_with_valid_state_and_matching_param_id args
    render_show args
  end
  def show_and_cookie_id_with_invalid_state_and_matching_param_id args
    generate_new_cookie_id_set_cookie_and_redirect_to_show args
  end
  def show_and_cookie_id_with_valid_state_and_not_matching_param_id_with_valid_state args
    render_show args
  end
  def show_and_cookie_id_with_valid_state_and_not_matching_param_id_with_invalid_state args
    render_show args
  end
  def show_and_cookie_id_with_invalid_state_and_not_matching_param_id_with_valid_state args
    set_cookie_and_render_show args
  end
  def show_and_cookie_id_with_invalid_state_and_not_matching_param_id_with_invalid_state args
    generate_new_cookie_id_set_cookie_and_redirect_to_show args
  end
  def show_and_no_cookie_id_and_param_id_with_valid_state args
    set_cookie_and_render_show args
  end
  def show_and_no_cookie_id_and_param_id_with_invalid_state args
    generate_new_cookie_id_set_cookie_and_redirect_to_show args
  end
  def generate_new_cookie_id_set_cookie_and_redirect_to_show args
    args[:cookie_id] = generate_new_cookie_id args
    set_cookie args
    redirect_to_show args
  end
  def set_cookie args
    name = cookie_id_name args
    expiry = cookie_expiration_date args
    cookies[name] = {:value => args[:cookie_id], :expires => expiry}
  end
  def redirect_to_show args
    redirect_to :action => 'show', :id => args[:cookie_id]
  end
  def set_cookie_and_render_show args
    set_cookie args
    render_show args
  end
  def cookie_expiration_date args
    10.years.from_now
  end
  def super_simple_auth_index args={}
    set_up_index_args args
    if not cookies[cookie_id_name(args)].nil?
      args[:cookie_state] = get_cookie_state(args)
    end
    super_simple_auth args
  end
  def super_simple_auth_show args={}
    set_up_show_args args
    args[:param_state] = get_param_state args
    if not cookies[cookie_id_name(args)].nil?
      args[:cookie_state] = get_cookie_state(args)
    end
    super_simple_auth args
  end
  def set_up_index_args args
    args[:method] = :index
    args[:cookie_id] = cookies[cookie_id_name(args)]
  end
  def set_up_show_args args
    args[:method] = :show
    args[:cookie_id] = cookies[cookie_id_name(args)]
    args[:param_id] = params[param_id_name(args)]
  end
  def super_simple_auth args
    if (args[:method] == :index and
        args[:cookie_id].nil?)

        index_and_no_cookie_id args

    elsif (args[:method] == :index and
           not args[:cookie_id].nil? and
           args[:cookie_state])

           index_and_cookie_id_with_valid_state args

    elsif (args[:method] == :index and
           not args[:cookie_id].nil? and
           not args[:cookie_state])

           index_and_cookie_id_with_invalid_state args

    elsif (args[:method] == :show and
           not args[:cookie_id].nil? and
           args[:cookie_state] and
           args[:cookie_id] == args[:param_id])

           show_and_cookie_id_with_valid_state_and_matching_param_id args

    elsif (args[:method] == :show and
           not args[:cookie_id].nil? and
           not args[:cookie_state] and
           args[:cookie_id] == args[:param_id])

           show_and_cookie_id_with_invalid_state_and_matching_param_id args

    elsif (args[:method] == :show and
           not args[:cookie_id].nil? and
           args[:cookie_state] and
           args[:cookie_id] != args[:param_id] and
           args[:param_state])

           show_and_cookie_id_with_valid_state_and_not_matching_param_id_with_valid_state args

    elsif (args[:method] == :show and
           not args[:cookie_id].nil? and
           args[:cookie_state] and
           args[:cookie_id] != args[:param_id] and
           not args[:param_state])

           show_and_cookie_id_with_valid_state_and_not_matching_param_id_with_invalid_state args

    elsif (args[:method] == :show and
           not args[:cookie_id].nil? and
           not args[:cookie_state] and
           args[:cookie_id] != args[:param_id] and
           args[:param_state])

           show_and_cookie_id_with_invalid_state_and_not_matching_param_id_with_valid_state args

    elsif (args[:method] == :show and
           not args[:cookie_id].nil? and
           not args[:cookie_state] and
           args[:cookie_id] != args[:param_id] and
           not args[:param_state])

           show_and_cookie_id_with_invalid_state_and_not_matching_param_id_with_invalid_state args

    elsif (args[:method] == :show and
           args[:cookie_id].nil? and
           not [:param_id].nil?
           args[:param_state])

           show_and_no_cookie_id_and_param_id_with_valid_state args

    elsif (args[:method] == :show and
           args[:cookie_id].nil? and
           not [:param_id].nil?
           not args[:param_state])

           show_and_no_cookie_id_and_param_id_with_invalid_state args
    end
  end
end
