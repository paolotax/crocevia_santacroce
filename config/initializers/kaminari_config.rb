Kaminari.configure do |config|
  # config.default_per_page = 25 
  config.window = 3
  # config.outer_window = 0
  config.left = 0
  config.right = 0
  config.page_method_name = :pagina
  config.param_name = :page
end
