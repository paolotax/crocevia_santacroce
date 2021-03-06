# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format
# (all these examples are active by default):
ActiveSupport::Inflector.inflections do |inflect|
  inflect.plural /^(ox)$/i, '\1en'
  inflect.singular /^(ox)en/i, '\1'
  inflect.irregular 'articolo', 'articoli'
  inflect.irregular 'cliente', 'clienti'
  inflect.irregular 'categoria', 'categorie'  
  inflect.irregular 'movimento', 'movimenti'
  inflect.irregular 'documento', 'documenti'
  inflect.irregular 'vendita', 'vendite'
  inflect.irregular 'resa', 'rese'
  inflect.uncountable %w( fish sheep )
end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.acronym 'RESTful'
# end
