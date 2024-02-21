class TotalResenhasController < ApplicationController
  before_action :set_total_resenha, only: %i[ show update destroy ]

  # GET /total_resenhas
  def index
    @total_resenhas = TotalResenha.all

    render json: @total_resenhas
  end

  # GET /total_resenhas/1
  def show
    render json: @total_resenha
  end

  # POST /total_resenhas
  def create
    @total_resenha = TotalResenha.new(total_resenha_params)

    if @total_resenha.save
      render json: @total_resenha, status: :created, location: @total_resenha
    else
      render json: @total_resenha.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /total_resenhas/1
  def update
    if @total_resenha.update(total_resenha_params)
      render json: @total_resenha
    else
      render json: @total_resenha.errors, status: :unprocessable_entity
    end
  end

  # DELETE /total_resenhas/1
  def destroy
    @total_resenha.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_total_resenha
      @total_resenha = TotalResenha.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def total_resenha_params
      params.require(:total_resenha).permit(:libro_id, :cantidad, :sumatoria, :media)
    end
end
