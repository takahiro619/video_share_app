class LoginlessViewersController < ApplicationController
  before_action :set_loginless_viewer, except: %i[index new create]
  layout 'loginless_viewers_auth'

  def index
    @loginless_viewers = LoginlessViewer.all
    if current_system_admin
      render :layout => 'system_admins'
    elsif current_user
      render :layout => 'users'
    end
  end

  def new
    @loginless_viewer = LoginlessViewer.new
  end

  def create
    @loginless_viewer = LoginlessViewer.new(loginless_viewer_params)
    if @loginless_viewer.save
      flash[:success] = "#{@loginless_viewer.name}の作成に成功しました"
      redirect_to loginless_viewers_url
    else
      render :new
    end
  end

  def show; end

  def destroy
    @loginless_viewer.destroy!
    flash[:danger] = "#{@loginless_viewer.name}のユーザー情報を削除しました"
    redirect_to loginless_viewers_url
  end

  private

  def loginless_viewer_params
    params.require(:loginless_viewer).permit(:name, :email)
  end

  def set_loginless_viewer
    @loginless_viewer = LoginlessViewer.find(params[:id])
  end
end