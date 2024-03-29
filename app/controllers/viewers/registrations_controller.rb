# frozen_string_literal: true

module Viewers
  class RegistrationsController < Devise::RegistrationsController
    layout 'viewers_auth'
    # before_action :configure_sign_up_params, only: [:create]
    # before_action :configure_account_update_params, only: [:update]

    # GET /resource/sign_up
    # def new
    #   super
    # end

    # POST /resource
    def create
      # ここでUser.new（と同等の操作）を行う
      build_resource(sign_up_params)

      # ここでUser.save（と同等の操作）を行う
      resource.save

      # ブロックが与えられたらresource(=User)を呼ぶ
      yield resource if block_given?
      if resource.persisted?
        # 先程のresource.saveが成功していたら
        if resource.active_for_authentication?
          # confirmable/lockableどちらかのactive_for_authentication?がtrueだったら
          # flashメッセージを設定
          set_flash_message! :notice, :signed_up
          # サインアップ操作
          sign_up(resource_name, resource)
          # リダイレクト先を指定
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          flash[:success] = '送られてくるメールの認証URLからアカウントの認証をしてください。'
          # sessionを削除
          expire_data_after_sign_in!
          respond_with resource, location: new_viewer_session_path
        end
      else
        # 先程のresource.saveが失敗していたら
        # passwordとpassword_confirmationをnilにする
        clean_up_passwords resource
        # validatable有効時に、パスワードの最小値を設定する
        set_minimum_password_length
        respond_with resource
      end
    end

    # GET /resource/edit
    def edit
      redirect_to root_url
    end

    # PUT /resource
    # def update
    #   super
    # end

    # DELETE /resource
    # def destroy
    #   super
    # end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

    # protected

    def after_update_path_for(_resource)
      viewers_path
    end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_up_params
    #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
    # end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_account_update_params
    #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
    # end

    # The path used after sign up.
    # def after_sign_up_path_for(resource)
    #   super(resource)
    # end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end
  end
end
