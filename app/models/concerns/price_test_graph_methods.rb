module PriceTestGraphMethods
  ## coding practice to refactor below
  ## move graphing related code to seperate module
  def plot_data
    price_data.values.map.with_index do |hash, index|
      {
        y: hash['revenue'],
        x: hash['price_points'],
        z: variants[index].variant_title,
        unit_cost: variants[index].unit_cost,
        total_variant_views: hash['total_variant_views']
      }
    end
  end

  def final_plot
    plot_data.map {|val| get_value(val) }
  end

  def revenue_hash
    final_plot.map { |val| val.map{ |obj| { y: obj[:revenue], x: obj[:x], variant_title: obj[:z] } } }
  end

  def profit_hash
    final_plot.map { |val| val.map{ |obj| { y: obj[:profit], x: obj[:x], variant_title: obj[:z] } } }
  end

  def revenue_per_view_hash
    final_plot.map { |val| val.map{ |obj| { y: obj[:rev_per_view], x: obj[:x], variant_title: obj[:z] } } }
  end

  def profit_per_view_hash
    final_plot.map { |val| val.map{ |obj| { y: obj[:profit_per_view], x: obj[:x], variant_title: obj[:z] } } }
  end

  def get_value(hash)
    unit_cost = hash[:unit_cost]
    unit_cost = 0 if unit_cost.nil?
    while hash[:y].length < hash[:x].length
      hash[:y] << 0
      hash[:total_variant_views] << 0
    end
    a = hash[:y].map {|val| { y: val.round(2)} }
    a = hash[:x].map{ { y: 0 } } if a.empty?
    b = hash[:x].map {|val| { x: val} }
    b = hash[:x].map{ { x: 0 } } if b.empty?
    total_variant_views = hash[:total_variant_views].map{|val| {total_variant_views: val}}
    total_variant_views = hash[:x].map{ { total_variant_views: 0 } } if total_variant_views.empty?
    analytics_hash = { z: hash[:z] }
    a.map.with_index do  |val,index|
      total_variant_views[index][:total_variant_views] == 0 ? rev_per_view = 0 :
        rev_per_view = a[index][:y]/total_variant_views[index][:total_variant_views]
      rev = a[index][:y]
      price_point = b[index][:x]
      profit = (rev-((rev/price_point)*unit_cost))
      views = total_variant_views[index][:total_variant_views]
      views == 0.0 ? profit_per_view = 0.0 : profit_per_view = (profit/views).round(4)
      val.merge(b[index]).
        merge(total_variant_views[index]).
        merge(analytics_hash).
        merge({rev_per_view: rev_per_view.round(4)}).
        merge({profit: (a[index][:y]-((a[index][:y]/b[index][:x])*unit_cost)).round(2) }).
        merge({profit_per_view: profit_per_view }).
        merge({revenue: rev})
    end
  end
end