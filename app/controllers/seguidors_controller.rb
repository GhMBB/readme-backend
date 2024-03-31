class SeguidorsController < ApplicationController
  before_action :set_seguidor, only: %i[ show update destroy ]

  # GET /seguidors
  def index
    @seguidors = Seguidor.all

    render json: @seguidors
  end

  # GET /seguidors/1
  def show
    render json: @seguidor
  end

  # POST /seguidors
  def create
    @seguidor = Seguidor.new(seguidor_params)

    if @seguidor.save
      render json: @seguidor, status: :created, location: @seguidor
    else
      render json: @seguidor.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /seguidors/1
  def update
    if @seguidor.update(seguidor_params)
      render json: @seguidor
    else
      render json: @seguidor.errors, status: :unprocessable_entity
    end
  end

  # DELETE /seguidors/1
  def destroy
    @seguidor.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_seguidor
      @seguidor = Seguidor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def seguidor_params
      params.fetch(:seguidor, {})
    end
end
