class ResenhasController < ApplicationController
  before_action :set_resenha, only: %i[ show update destroy ]

  # GET /resenhas
  def index
    @resenhas = Resenha.all

    render json: @resenhas
  end

  # GET /resenhas/1
  def show
    render json: @resenha
  end

  # POST /resenhas
  def create
    @resenha = Resenha.new(resenha_params)

    if @resenha.save
      render json: @resenha, status: :created, location: @resenha
    else
      render json: @resenha.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /resenhas/1
  def update
    if @resenha.update(resenha_params)
      render json: @resenha
    else
      render json: @resenha.errors, status: :unprocessable_entity
    end
  end

  # DELETE /resenhas/1
  def destroy
    @resenha.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resenha
      @resenha = Resenha.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def resenha_params
      params.require(:resenha).permit(:user_id, :libro_id, :puntuacion)
    end
end
