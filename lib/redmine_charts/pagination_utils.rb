module RedmineCharts
  module PaginationUtils
    def self.from_params(params)
      {
        page: params[:page].blank? ? 1 : Integer(params[:page]),
        per_page: params[:per_page].blank? ? 10 : Integer(params[:per_page]),
      }
    end
  end
end
