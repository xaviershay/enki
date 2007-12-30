module FormHelper
  def admin_form_for(object, &proc)
    form_for(object, :builder => AdminFormBuilder, &proc)
  end
end
