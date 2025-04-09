# README

## How to Use the Application:

### Creating an Account
1. Open a new terminal window and run `git clone git@github.com:zacherynolan/mfa-project.git banking_app` in a folder of your choice.
2. Navigate to the new folder by running `cd banking_app`
3. Run `rails server`
4. Open **localhost:3000** in a browser window
5. Select **Sign Up** in the top right-hand corner
6. Complete the required information and select **Create User**

### Enabling 2FA
1. Once you are registered and logged in, select **Hi, [your email]** at the top
2. Select **Enable 2FA**
3. Download **Google Authenticator** on your mobile device
4. Inside of the authenticator app, scan the QR code
5. Enter the six-digit OTP code and submit

### Disabling 2FA
1. Select **Hi, [your email]** at the top
2. Enter the six-digit OTP found in your authenticator app
3. Enter your current password under **Current Password** and submit

*Note, be sure not to delete the 2FA session from your authenticator app without first disabling 2FA in the banking app. Doing so will lock you out of your account.
