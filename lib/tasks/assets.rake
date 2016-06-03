namespace :assets do
  task :precompile => :gulp_compile

  # ***WARNING***
  # Temporary shim until these steps are properly integrated into deploy.
  # Do not use for anything otherwise!
  task :gulp_compile do
    system "cd #{Shellwords.escape(Rails.root)} && npm install --spin=false"
    system "cd #{Shellwords.escape(Rails.root)} && bin/gulp"
    raise 'Command failed!' unless $?.success?
  end
end
