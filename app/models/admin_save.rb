module AdminSave

  def save_as_admin
    set_as_admin { save }
  end

  def update_as_admin(attrs)
    set_as_admin { update(attrs) }
  end

  protected

  def as_admin?
    instance_variable_defined?(:@_admin)
  end

  def set_as_admin
    @_admin = true
    to_return = yield
    remove_instance_variable(:@_admin)
    to_return
  end

end
