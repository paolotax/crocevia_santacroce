module ArticoliHelper

  def table_articoli(collection, name='', options={})
    content_tag :table, class: "table #{name}" do
      render collection
    end  
  end

end