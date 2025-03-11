class UsersController < ApplicationController

    def new
        @user = User.new
        render :new
    end

    def create
        @user = User.new(params.require(:user).permit(:name, :address, :email, :phone, :password))
        
        if @user.save
            flash[:success] = 'Registration Successful!'
            redirect_to home_url
        else
            flash.now[:error] = 'Registration failed...'
            render :new, status: :unprocessable_entity
        end
    end
end
