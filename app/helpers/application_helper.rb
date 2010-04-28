module ApplicationHelper
  def body_class
    qualified_controller_name = controller.controller_path.gsub('/','-')
    "#{qualified_controller_name} #{qualified_controller_name}-#{controller.action_name}"
  end

  def link_to_twitter_profile(twitter)
    link_to(twitter.name, "http://twitter.com/#{twitter.handle}")
  end

  def link_to_vk_profile(vk)
    link_to(vk.username, "http://vkontakte.ru/#{vk.uid}")
  end
end
