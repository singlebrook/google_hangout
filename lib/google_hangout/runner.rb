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

      # Check for various error conditions and get back into the chat if necessary
      thread = Thread.new(page) do |main_page|
        while true do
          if main_page.body.match /Are you still there?/
            main_page.find('div[role="button"]', :text => 'Yes').click
          end

          if main_page.body.match /The video call ended because of an error/
            main_page.find('div[role="button"]', :text => 'Try Again').click
            main_page.find('div[role="button"]', :text => 'Join').click
          end

          if main_page.body.match /You left the video call/
            main_page.visit hangout_url
            main_page.find('div[role="button"]', :text => 'Join').click
          end

          sleep 5
        end
      end

      # Wait for some input so script doesn't exit
      puts "Press Return to quit"
      STDIN.gets

      # Clean up
      thread.kill
    end
  end
end