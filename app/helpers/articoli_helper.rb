module ArticoliHelper

  def table_articoli(collection, name='')
    content_tag :table, class: "table #{name}" do
      render collection
    end  
  end

end