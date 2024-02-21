class FavoritosController < ApplicationController
  before_action :set_favorito, only: %i[ show update destroy ]

  # GET /favoritos
  def index
    @favoritos = Favorito.all

    render json: @favoritos
  end

  # GET /favoritos/1
  def show
    render json: @favorito
  end

  # POST /favoritos
  def create
    @favorito = Favorito.new(favorito_params)

    if @favorito.save
      render json: @favorito, status: :created, location: @favorito
    else
      render json: @favorito.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /favoritos/1
  def update
    if @favorito.update(favorito_params)
      render json: @favorito
    else
      render json: @favorito.errors, status: :unprocessable_entity
    end
  end

  # DELETE /favoritos/1
  def destroy
    @favorito.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_favorito
      @favorito = Favorito.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def favorito_params
      params.require(:favorito).permit(:user_id, :libro_id, :favorito)
    end
end
