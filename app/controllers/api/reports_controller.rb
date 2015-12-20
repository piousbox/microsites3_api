
class Api::ReportsController < Api::ApiController

  def index
    @reports = Report.page( params[:reports_page] ).per( Report::PER_PAGE )
    authorize! :index, Report.new
    respond_to do |format|
      format.json do
        render :json => @reports
      end
    end
  end

  def show
    @report = Report.where( :name_seo => params[:name_seo] ).first
    authorize! :show, @report
    
    respond_to do |format|
      format.json do
        render :json => @report
      end
    end
  end

end