class FavoritosController < ApplicationController
  before_action :authenticate_request
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
  user = get_user
  if user.nil? || (user.deleted == true)
    render json: {error: "El usuario no se encuentra"}, status: 400
    return
  end

  existe_favorito = Favorito.find_by(libro_id: params[:libro_id], user_id: user.id)

  if existe_favorito.present?
    existe_favorito.update(favorito_params)
    render json: existe_favorito, status: :ok
  else
    # Si no existe el favorito, crea un nuevo favorito
    @favorito = Favorito.new(favorito_params)
    @favorito.favorito = params[:fav]
    @favorito.deleted = false
    if @favorito.save
      render json: @favorito, status: :created, location: @favorito
    else
      render json: @favorito.errors, status: 400
    end
  end
end


  # PATCH/PUT /favoritos/1
  def update
    #Solo el usuario puede actualizar su fav
    user = get_user
  if user.nil?
    render json: {error: "El usuario no se encuentra"}, status: 400
    return
  end
     @favorito = Favorito.find_by(id: params[:id], deleted: false)
    if @favorito.update(favorito: params[:fav])
      render json: @favorito
    else
      render json: @favorito.errors, status: :unprocessable_entity
    end
  end

  # DELETE /favoritos/1
  def destroy
    @favorito.destroy!
  end

  # Método para buscar un favorito por user_id y libro_id
  # GET /favoritos/find_by
  def buscar_por_usuario_y_libro
    user = get_user
    if user.nil?
      render json: {error: "El usuario no se encuentra"}, status: 422
      return
   end
    #Verificar los parametros
    libro = Libro.find_by(id: params[:libro_id])
    if libro.nil?
      render json: { error: "El libro no fue encontrado" }, status: :bad_request
      return
    end


    @favorito = Favorito.find_by(user_id: user.id, libro_id: params[:libro_id],favorito: true, deleted: false)
    if @favorito
      render json: @favorito, status: :ok
    else
      render json: { error: 'Favorito no encontrado' }, status: :not_found
    end
  end

  def libros_favoritos_por_usuario
  begin
   user_id = params[:user_id]
   # Verificar si existe el usuario por su id
   usuario = User.find_by(id: user_id)
   # Si no se encuentra el usuario, devolver un error 404
   raise ActiveRecord::RecordNotFound.new("Usuario no encontrado") if usuario.nil?
   # Encuentra todos los favoritos del usuario dado
   @favoritos = Favorito.where(user_id: params[:user_id], favorito: true, deleted: false)

   if @favoritos.size >= 1
     # Extrae los IDs de los libros favoritos
     ids = @favoritos.pluck(:libro_id)
     # Encuentra los libros correspondientes a los IDs obtenidos y pagínalos
     @libros_favoritos = Libro.where(id: ids).paginate(page: params[:page])

     render json: @libros_favoritos, status: :ok
   else
     render json: { error: 'Favoritos no encontrados' }, status: :not_found
   end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_favorito
      @favorito = Favorito.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def favorito_params
      params.require(:favorito).permit(:libro_id, :fav => :boolean)
    end
end
