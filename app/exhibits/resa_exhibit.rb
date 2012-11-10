class ResaExhibit < DisplayCase::Exhibit
  # Note: the context parameter is new in the master branch, not yet released in the gem. 
  # If you get an argument error, that's why
  def self.applicable_to?(object, context) 
    object.class.name == 'Movimento' && object.resa?
  end

  def render_template(template)
    template.render(partial: 'movimenti/resa', locals: {movimento: self})
  end
end