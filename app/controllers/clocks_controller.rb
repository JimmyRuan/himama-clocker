class ClocksController < ApplicationController
  before_action :set_clock, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /clocks
  # GET /clocks.json
  def index
    @clocks = current_user.clocks().order(created_at: :desc).all
  end

  # GET /clocks/1
  # GET /clocks/1.json
  def show
    redirect_to edit_clock_path
  end

  # GET /clocks/new
  def new
    @clock = Clock.new
    @clock_message = is_next_clock_in ? 'Clock-In' : 'Clock-Out'
  end

  # GET /clocks/1/edit
  def edit
  end

  # POST /clocks
  # POST /clocks.json
  def create
    last_clock = get_last_clock


    if last_clock.blank? || last_clock.clock_out_time
      @clock = Clock.new
      @clock.clock_in_time = DateTime.now.utc
      @clock.user = current_user
    else
      @clock = last_clock
      @clock.clock_out_time = DateTime.now.utc
    end

    if @clock.save
      redirect_to clocks_path
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @clock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clocks/1
  # PATCH/PUT /clocks/1.json
  def update
      clock_in_time = Time.zone.parse(params['clock']['clock_in_time'])
      clock_out_time = Time.zone.parse(params['clock']['clock_out_time'])

      if clock_in_time.blank? || clock_out_time.blank?
        @clock.errors.add(:clock_in_time, '=> Invalid daytime value') if clock_in_time.blank?
        @clock.errors.add(:clock_out_time, '=> Invalid daytime value') if clock_out_time.blank?
      else
        @clock.clock_in_time = clock_in_time.to_datetime.utc
        @clock.clock_out_time = clock_out_time.to_datetime.utc
      end

      if ! @clock.errors.any? && @clock.save
        redirect_to clocks_path
      else
        respond_to do |format|
          format.html { render :edit }
          format.json { render json: @clock.errors, status: :unprocessable_entity }
        end
      end
  end

  # DELETE /clocks/1
  # DELETE /clocks/1.json
  def destroy
    @clock.destroy
    respond_to do |format|
      format.html { redirect_to clocks_url, notice: 'Clock was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clock
      @clock = Clock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clock_params
      params.require(:clock).permit(:clocked_in, :user_id)
    end

    def is_next_clock_in
      last_clock = get_last_clock
      # if this session is already checked out, a new clock session should be "clock-in"
      last_clock ?  !!last_clock.clock_out_time : true
    end

    def get_last_clock
      current_user.clocks().order(created_at: :desc).all.first
    end
end
