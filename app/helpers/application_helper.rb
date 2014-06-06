module ApplicationHelper
  def bootstrap_flash_class(name)
    case name.to_s
    when 'notice'
      'info'
    when 'error'
      'danger'
    else
      name.to_s
    end
  end

  def admin?
    current_subscriber && current_subscriber.admin
  end

  def next_wednesday
    Date.today.next_week.advance(days: 2).strftime("%d/%m/%Y")
  end
end
