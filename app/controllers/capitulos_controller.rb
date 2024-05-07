class CapitulosController < ApplicationController
  before_action :authenticate_request
  before_action :set_capitulo, only: %i[ show update destroy publicar ]

  #GET /capitulos/libro/1
  def libro
    user = get_user
    return if user.nil?

    if params[:libro_id].nil?
      render json: {error: "Debe proporcinoar el id del libro"}, status: 400
      return
    end
    libro = Libro.find_by(id: params[:libro_id],deleted:false)
    if libro.nil?
      render json: {error: "Libro no encontrado"}, status: 404
      return
    end

    capitulos = libro.capitulos.where(deleted:false).order(:indice)
    capitulos = capitulos.where(publicado: true) if user != libro.user

    capitulos.each do |capitulo|
      capitulo.contenido = obtener_contenido(capitulo.nombre_archivo)
    end

    if user == libro.user
      capitulos_serializados = capitulos.map{ |capitulo| CapituloForOwnerSerializer.new(capitulo).as_json }

      render json: capitulos_serializados,status: :ok
      return
    else
      capitulos_serializados = capitulos.map{ |capitulo| CapituloSerializer.new(capitulo).as_json }
      render json: capitulos_serializados,status: :ok
    end
  end


  # GET /capitulos/1
  def show
    user = get_user
    return if user.nil?

    if @capitulo.libro.deleted
      render json: {error: "Libro del capitulo eliminado"}, status: 404
      return
    end


    if @capitulo.libro.user != user && !@capitulo.publicado
      render json: {error: "Capitulo no encontrado"}, status: 404
      return
    end


    @capitulo.contenido = obtener_contenido(@capitulo.nombre_archivo)
    render json: @capitulo, serializer: user==@capitulo.libro.user ? CapituloForOwnerSerializer : CapituloSerializer
  end

  # POST /capitulos
  def create
    libro = Libro.find_by(id: params[:libro_id])
    usuario = get_user

    return if usuario.nil?

    if libro.nil?
      render json: {error: "Libro no encontrado"}, status: 404
      return
    end

    
    if libro.deleted
      render json: {error: "Libro del capitulo eliminado"}, status: 404
      return
    end

    if usuario != libro.user
      render json: {error: "Debes ser el propietario del libro para agregar capitulos."}, status: 404
      return
    end

    if !params[:contenido]
      render json: {error: "Debe proporcionar el contendio del capitulo"}, status: 404
      return
    end

    @capitulo = Capitulo.new(capitulo_params)
    @capitulo.libro = libro

    @capitulo.nombre_archivo = guardar_archivo

    if @capitulo.nombre_archivo == ""
      render json: {error: "No se pudo guardar el contenido del capitulo."}, status: 400
      return
    end

    if @capitulo.save
      @capitulo.contenido = obtener_contenido(@capitulo.nombre_archivo)

      if @capitulo.contenido == ""
        render json: {error: "No se pudo guardar el contenido del capitulo."}, status: 400
        return

      end
      render json:  @capitulo, serializer: CapituloForOwnerSerializer,status: :created
      return
    else
      render json: @capitulo.errors, status: :unprocessable_entity
      return
    end
  end

  # PATCH/PUT /capitulos/1
  def update
    user = get_user
    return if user.nil?

    libro = @capitulo.libro

    if @capitulo.libro.deleted
      render json: {error: "Libro del capitulo eliminado"}, status: 404
      return
    end


    if libro.user != user
      render json: { error: "Debes ser el propietario del libro para modificarlo." }, status: 400
      return
    end

    if !@capitulo.publicado && user != @capitulo.libro.user
      render json: {error: "Capitulo no encontrado"}, status: 404
      return
    end

    @capitulo.nombre_archivo = guardar_archivo()  if params[:contenido].present?
    @capitulo.titulo = params[:titulo] if params[:titulo].present?
    if @capitulo.save
      @capitulo.contenido = obtener_contenido(@capitulo.nombre_archivo)
      render json: @capitulo, serializer: CapituloForOwnerSerializer
    else
      render json: @capitulo.errors, status: :unprocessable_entity
    end
  end

  def publicar
    user = get_user
    return if user.nil?
  
    libro = @capitulo.libro
  
    if @capitulo.libro.deleted
      render json: { error: "Libro del capitulo eliminado" }, status: 404
      return
    end
  
    if libro.user != user
      render json: { error: "Debes ser el propietario del libro para modificarlo." }, status: 400
      return
    end
  
    @capitulo.publicado = !@capitulo.publicado
    if @capitulo.save
      if @capitulo.publicado
        NotificacionDeCapitulo.where(libro_id: @capitulo.libro.id, deleted: false).map do |notificacion|
          user = User.find(notificacion.user_id)
          NotificationMailer.with(user: user, capitulo: @capitulo, libro: @capitulo.libro).chapter_notification.deliver_later
        end
      end
      @capitulo.contenido = obtener_contenido(@capitulo.nombre_archivo)
      render json: @capitulo, serializer: CapituloForOwnerSerializer
    else
      render json: @capitulo.errors, status: :unprocessable_entity
    end
  end
  


  # DELETE /capitulos/1
  def destroy
    user = get_user

    return if user.nil?

    libro = @capitulo.libro

    if libro.user != user && user.role != "moderador"
      render json: { error: "Debes ser el propietario del libro o ser moderador para modificarlo." }, status: 400
      return
    end

    @capitulo.deleted = true
    if @capitulo.save
      capitulos_del_libro = libro.capitulos.where(deleted:false)

      render status: :ok
    else
      render json: {error: "No se pudo eliminar el libro"}, status: 400
    end

  end

  # put /swap/capitulos
  def swap
    capitulo1 = Capitulo.find_by(id: params[:capitulo1_id], deleted: false)
    capitulo2 = Capitulo.find_by(id: params[:capitulo2_id], deleted: false)

    if capitulo1.nil?
      render json: { error: "No se encontró el capitulo con el id=" + params[:capitulo1_id] }, status: 404
      return
    end

    if capitulo2.nil?
      render json: { error: "No se encontró el capitulo con el id=" + params[:capitulo2_id] }, status: 404
      return
    end

    if capitulo1.libro != capitulo2.libro
      render json: { error: "Los capitulos no pertenecen al mismo libro." }, status: 400
      return
    end

    if capitulo1.libro.deleted
      render json: {error: "Libro de los capitulos eliminado"}, status: 404
      return
    end

    libro = capitulo1.libro
    user = get_user

    if user.nil?
      return
    end

    if libro.user != user
      render json: { error: "Debes ser el propietario del libro para modificarlo." }, status: 400
      return
    end

    Capitulo.transaction do
      temp_indice = capitulo1.indice

      capitulo1.update!(indice: capitulo2.indice)
      capitulo2.update!(indice: temp_indice)

      capitulos_del_libro = Capitulo.where(libro_id: capitulo1.libro_id, deleted: false)
    end

    render json: { message: "Intercambio de índices realizado exitosamente" }
    return
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
    return
  end


  private
  def guardar_archivo
    if params[:contenido].present?
      begin
        cloudinary_response = Cloudinary::Uploader.upload(params[:contenido], resource_type: :auto, folder: "capitulos")
        return cloudinary_response['public_id']
      rescue CloudinaryException => e
        return ""
      end
    else
      return ""
    end
  end

  def obtener_contenido(contenido_public_id)
    if !contenido_public_id
      return ""
    end

    begin
      enlace_temporal = Cloudinary::Utils.cloudinary_url("#{contenido_public_id}", :resource_type => :raw, :expires_at => (Time.now + 3600).to_i)
      return enlace_temporal
    rescue CloudinaryException => e
      return ""
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_capitulo
    @capitulo = Capitulo.find_by(id: params[:id],deleted:false)
    if @capitulo.nil?
      render json: {error: "Capitulo no encontrado"}, status: 404
      return
    end
  end

  # Only allow a list of trusted parameters through.
  def capitulo_params
    params.permit(:libro_id, :titulo)
  end
end