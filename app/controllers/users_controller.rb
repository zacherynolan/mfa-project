class UsersController < ApplicationController
    before_action :authenticate_user!, except: [:new, :create]
    
    def show
        @user = User.find(params[:id])
        render :show
    end
    
    def new
        @user = User.new
        render :new
    end

    def create
        @user = User.new(params.require(:user).permit(:name, :address, :email, :phone, :password))
        
        if @user.save
            flash[:success] = 'Registration Successful!'
            redirect_to user_url(@user)
        else
            flash.now[:error] = 'Registration failed...'
            render :new, status: :unprocessable_entity
        end
    end
end
