class ResaExhibit < DisplayCase::Exhibit

  def self.applicable_to?(object, context) 
    object.class.name == 'Movimento' && object.resa?
  end

  def render_template(template)
    template.render(partial: 'movimenti/resa', locals: {movimento: self})
  end
end