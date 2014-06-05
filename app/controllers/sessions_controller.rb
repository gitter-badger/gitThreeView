class SessionsController < ApplicationController

  def index
    demoID = User.find_by(name: "ajkamel").github_access_token
    @oauth_link = "https://github.com/login/oauth/authorize?client_id=#{ENV['GITHUB_CLIENT_ID']}"
    @demouser= "/demo/#{demoID}"
  end

  def callback
    oauth_response = User.oauth_response(params["code"])
    client = User.new_client(oauth_response)
    session[:github_access_token] = oauth_response["access_token"]

    unless User.exists?(name: client.login)
      User.create(name: client.login,
        github_access_token: oauth_response["access_token"],
        avatar: client.user.avatar_url,
        email: client.user.email )
    end
    redirect_to welcome_index_path
  end

  def demo
    client = User.new_client(params[:id])
    session[:github_access_token] = params[:id]
    redirect_to welcome_index_path
  end

  def destroy
    session[:github_access_token] = nil
    redirect_to root_path
  end

end
