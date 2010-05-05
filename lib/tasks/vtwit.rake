namespace :vtwit do
  task :sync => :environment do
    User.all.each do |user|
      puts "Sync statuses for VK: #{user.vk.mid} and TW: #{user.twitter.handle}"
      user.sync
    end
  end
end

