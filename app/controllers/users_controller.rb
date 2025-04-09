class UsersController < ApplicationController
    before_action :authenticate_user!, except: [:new, :create, :show_otp, :verify_otp]
    
    def show
        @user = User.find(params[:id])
        render :show
    end
    
    def new
        @user = User.new
        render :new
    end

    def edit
        @user = User.find(params[:id])
        render :edit
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

    def update
        @user = User.find(params[:id])
        if @user.update(params.require(:user).permit(:name, :address, :email, :phone, :balance))
            flash[:success] = 'Account successfully updated!'
            redirect_to user_url(@user)
        else
            flash.now[:error] = 'Account update failed...'
            render :edit, status: :unprocessable_entity
        end
    end

    def show_otp
        render :show_otp
    end

    def verify_otp
        verifier = Rails.application.message_verifier(:otp_session)
        user_id = verifier.verify(session[:otp_token])
        user = User.find(user_id)

        if user.validate_and_consume_otp!(params[:otp_attempt])
            sign_in(:user, user)
            redirect_to root_path, notice: "Logged in successfully!"
        else
            flash[:alert] = 'Invalid OTP code.'
            redirect_to new_user_session_path
        end
    end

    def enable_otp_show_qr
        if current_user.otp_required_for_login
            redirect_to edit_user_registration_path alert:'2FA is already enabled'
        else
            current_user.otp_secret = User.generate_otp_secret
            issuer = "Your App"
            label = "#{issuer}:#{current_user.email}"
            
            @provisioning_uri = current_user.otp_provisioning_uri(current_user.email, issuer: "Devise-Two-Factor-Demo")
            current_user.save!
        end
    end

    def enable_otp_verify
        if current_user.validate_and_consume_otp!(params[:otp_attempt])
            current_user.otp_required_for_login = true
            current_user.save!
            redirect_to edit_user_registration_path, notice: "2FA enabled successfully."
        else
            redirect_to enable_otp_show_qr_path, alert: "Invalid OTP code."
        end
    end

    def disable_otp
        current_user.otp_required_for_login = false
        current_user.save!
        redirect_to root_path
    end
end
