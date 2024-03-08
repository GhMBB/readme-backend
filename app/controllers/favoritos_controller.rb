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
    if user.nil?
      render json: {error: "El usuario no se encuentra"}, status: 400
      return
    end

    existe_favorito = Favorito.find_by(libro_id: params[:libro_id], user_id: user.id)

    if existe_favorito.present?
      existe_favorito.update(libro_id: params[:libro_id], user_id: user.id, favorito: params[:fav])
      render json: { message: 'Favorito actualizado exitosamente', favorito: FavoritoSerializer.new(existe_favorito) }, status: :ok
      return
    else
      @favorito = Favorito.new(libro_id: params[:libro_id], user_id: user.id)
      @favorito.favorito = params[:fav]
      @favorito.deleted = false
      if @favorito.save
        render json: { message: 'Favorito creado exitosamente', favorito: FavoritoSerializer.new(@favorito) }, status: :created, location: @favorito
        return
      else
        render json: @favorito.errors, status: 400
        return
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
      return render json: { message: 'Favorito actualizado exitosamente', favorito: FavoritoSerializer.new(@favorito) }, status: :ok
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

=begin
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

        @libros_favoritos.each do |libro|
          libro.portada = obtener_portada(libro.portada)
        end  

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
=end

  def libros_favoritos_por_usuario
    begin
      user_id = params[:user_id]
      # Verificar si existe el usuario por su id
      usuario = User.find_by(id: user_id)
      # Si no se encuentra el usuario, devolver un error 404
      raise ActiveRecord::RecordNotFound.new("Usuario no encontrado") if usuario.nil?

      # Encuentra todos los favoritos del usuario dado
      favoritos_query = Favorito.where(user_id: params[:user_id], favorito: true, deleted: false)


      if params[:busqueda].present?
        search_term = params[:busqueda].downcase
        favoritos_query = favoritos_query.joins(libro: :user)
                                         .where("LOWER(libros.titulo) LIKE ? OR LOWER(users.username) LIKE ?", "%#{search_term}%", "%#{search_term}%")
      end


      @favoritos = favoritos_query

      if @favoritos.size >= 1
        # Extrae los IDs de los libros favoritos
        ids = @favoritos.pluck(:libro_id)
        # Encuentra los libros correspondientes a los IDs obtenidos y pagínalos
        @libros_favoritos = Libro.where(id: ids).paginate(page: params[:page])

        @libros_favoritos.each do |libro|
          libro.portada = obtener_portada(libro.portada)
        end

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

  def obtener_portada(portada_public_id)
    if !portada_public_id
      return ""
    end

    begin
      enlace_temporal = Cloudinary::Utils.cloudinary_url("#{portada_public_id}", :resource_type => :image, :expires_at => (Time.now + 3600).to_i)
      return enlace_temporal
    rescue CloudinaryException => e
      puts "Error al obtener la portada de Cloudinary: #{e.message}"
      return ""
    end
  end

    # Use callbacks to share common setup or constraints between actions.
  def set_favorito
    @favorito = Favorito.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
  def favorito_params
    params.require(:favorito).permit(:libro_id,:user_id ,:fav, :busqueda)
  end
end
