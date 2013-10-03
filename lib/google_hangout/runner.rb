module GoogleHangout
  class Runner
    include Capybara::DSL

    def open(hangout_url, email, password)
      Capybara.default_driver = :selenium
      Capybara.app_host = hangout_url

      # Go there
      visit '/'

      # Log in if not already logged in
      begin
        find_field('Email')
        if email.nil? || email.empty? || password.nil? || password.empty?
          puts "ERROR: You aren't logged in to Google, but you did not supply login credentials."
          return
        end
        fill_in 'Email', with: email
        fill_in 'Password', with: password
        click_button 'Sign in'
      rescue Capybara::ElementNotFound
        # User is already logged in
      end

      find('div[role="button"]', :text => 'Join').click

      # Make it full screen
      `osascript -e 'tell application "System Events" to keystroke "f" using {command down, control down}'`

      # TODO: Fire off new thread to poll and check if we've gotten logged out?

      # Wait for some input so script doesn't exit
      puts "Press Return to quit"
      STDIN.gets
    end
  end
end