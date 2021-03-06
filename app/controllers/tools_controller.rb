class ToolsController < ApplicationController

  before_action :set_tool, only: [:show, :edit, :update, :destroy]
  after_action :authorize_access, only: [:show, :new, :create, :edit, :update, :destroy]

  def index
    if params[:query].present?
      @tools = policy_scope(Tool).where("title ILIKE ?", "%#{params[:query]}%")
    else
      @tools = policy_scope(Tool)
      @tools_geo = Tool.where.not(latitude: nil, longitude: nil)

      @markers = @tools_geo.map do |tool|
        {
          lat: tool.latitude,
          lng: tool.longitude#,
        }
      end
    end

  end

  def show
    @booking = Booking.new
  end

  def new
    @tool = Tool.new
  end

  def create
    @tool = Tool.new(tool_params)
    @tool.user = current_user
    if @tool.save
      redirect_to tool_path(@tool)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @tool.update(tool_params)
  end

  def destroy
    @tool.destroy
  end

  private

  def tool_params
    params.require(:tool).permit(:title, :price_per_day, :photo, :address)
  end

  def set_tool
    @tool = Tool.find(params[:id])
  end

  def authorize_access
    authorize @tool
  end
end
