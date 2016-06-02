module DrawerHelper
  def click_menu_link(name)
    page.find('.menu-icon').click
    within('.drawer-contents') do
      sleep 0.5
      click_link name
    end
  end
end

RSpec.configure do |c|
  c.include DrawerHelper
end
