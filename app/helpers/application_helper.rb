module ApplicationHelper

  def link_to_add_fields(name, f, type)
    new_object = f.object.send "build_#{type}"
    id = "new_#{type}"
    fields = f.send("#{type}_fields", new_object, child_index: id) do |builder|
      render(type.to_s + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end
  
  def badge_if(value, *args)
    
    if value && value > 0
    
      if args[0].has_key?(:class)
        args[0][:class] = args[0][:class] + " badge"
      else
        args.merge(:class => 'badge')
      end
      
      content_tag( :span, *args) do
        value.to_s
      end
    end
  end

end
