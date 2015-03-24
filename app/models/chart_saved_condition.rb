class ChartSavedCondition < ActiveRecord::Base
  validates_uniqueness_of :name, scope: :project_id
  validates_presence_of :name, :chart, :conditions

  belongs_to :project

  def conditions=(conditions)
    query = conditions.select { |_k, v| v }.map do |k, v|
      if v.is_a? Array
        v.map { |s| "#{k}[]=#{s}" }
      else
        "#{k}=#{v}"
      end
    end

    write_attribute :conditions, query.flatten.join('&')
  end
end
