class FavoritosController < ApplicationController
  before_action :authenticate_request
  before_action :set_favorito, only: %i[show update destroy]

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
    user = get_user
    if user.nil?
      render json: { error: "El usuario no se encuentra" }, status: 400
      return
    end
    favorito = Favorito.create_favorito(favorito_params, user)
    render_favorito_response(favorito)
  end

  # PATCH/PUT /favoritos/1
  def update
    @favorito.update_favorito(favorito_params)
    render json: @favorito
  end

  # DELETE /favoritos/1
  def destroy
    @favorito.destroy
  end

  # GET /favoritos/find_by
  def buscar_por_usuario_y_libro

    @favorito = Favorito.buscar_por_usuario_y_libro(params[:libro_id], params[:user_id])
    render json: @favorito, status: 200
  end

  # GET /favoritos/libros_favoritos_por_usuario
  def libros_favoritos_por_usuario
    @libros_favoritos = Favorito.libros_favoritos_por_usuario(params)
    render json: @libros_favoritos, stauts: 200
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_favorito
    @favorito = Favorito.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def favorito_params
    params.permit(:libro_id, :fav, :busqueda, :user_id)
  end

  def render_favorito_response(favorito)
    if favorito.persisted?
      render json: { message: favorito.persisted? ? 'Favorito creado/actualizado exitosamente' : 'Error al crear/actualizar el favorito', favorito: FavoritoSerializer.new(favorito) }, status: favorito.persisted? ? :created : :unprocessable_entity
    else
      render json: favorito.errors, status: :unprocessable_entity
    end
  end

end
