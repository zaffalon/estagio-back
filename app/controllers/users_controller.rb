# encoding: utf-8


class UsersController < ApplicationController
  # before_filter :back_to_default_tenant
  before_action :authenticate, except: [:create, :locate]
  after_action :log_request

  def create
    @user = User.new(user_params)
    if @user.save
      render json: { key: @user.user_tokens.first.token}
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  # def invite_params

  def user_params
    params.permit(:name, :email)
  end

end

