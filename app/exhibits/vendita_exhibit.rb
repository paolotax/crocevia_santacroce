class VenditaExhibit < DisplayCase::Exhibit
  # Note: the context parameter is new in the master branch, not yet released in the gem. 
  # If you get an argument error, that's why
  def self.applicable_to?(object, context) 
    object.class.name == 'Movimento' && object.vendita?
  end

  def render_template(template)
    template.render(partial: 'movimenti/vendita', locals: {movimento: self})
  end
end