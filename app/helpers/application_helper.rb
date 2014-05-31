module ApplicationHelper
  def flash_class(level)
    case level
    when :notice then "alert alert-info"
    when :success then "alert alert-success"
    when :error then "alert alert-error"
    when :alert then "alert alert-error"
    end
  end

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
end
