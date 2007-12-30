module FormHelper
  def admin_form_for(object, &p)
    form_for(object, :builder => AdminFormBuilder, &p)
  end
end
