class Metric < ActiveRecord::Base
  belongs_to :shop
  ## use .starts_with? to find product matches with price test
  def data=(google_data_object)
    if google_data_object.is_a? Array
      super
    else
      self[:data] = google_data_object.reports[0].data.rows.map do |row|
                      {
                        title: row.dimensions[0],
                        revenue: row.metrics[0].values[0],
                        views: row.metrics[0].values[1],
                        avg_price: row.metrics[0].values[2]
                      }
                    end
    end
  end
end