class RimborsoExhibit < DisplayCase::Exhibit

  def self.applicable_to?(object, context) 
  	object.class.name == 'Movimento' && object.vendita? && !object.rimborso_id.nil?
  end

  def render_template(template)
    template.render(partial: 'movimenti/rimborso', locals: {movimento: self})
  end
end