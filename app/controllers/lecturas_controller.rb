class LecturasController < ApplicationController
  before_action :authenticate_request
  before_action :set_lectura, only: %i[ show destroy ]


  # GET /lecturas/1
  def show
    render json: @lectura
  end

  # POST /lecturas
  def create
    user = get_user
    if user.nil?
      render json: {error: "El usuario no se encuentra"}, status: 400
      return
    end
    libro_id = params[:libro_id]
    capitulo_id = params[:capitulo_id]

    if libro_id.blank?
      return render json: { error: 'Falta el id del libro' }, status: :unprocessable_entity
    elsif capitulo_id.blank?
      return render json: { error: 'Falta el id del capitulo' }, status: :unprocessable_entity
    end

    libro = Capitulo.find_by(id: capitulo_id, libro_id: libro_id)
    if libro.nil?
      return render json: {error: "El capitulo no pertenece al libro"},status: :unprocessable_entity
    end

    leyendo = Lectura.find_by(libro_id: libro_id, user_id: user.id)

    if leyendo.present?
      leyendo.update(capitulo_id: params[:capitulo_id], terminado: params[:terminado], deleted: false)
      return render json: {message:"Progreso de lectura actualizado exitosamente", Lectura: LecturaSerializer.new(leyendo) }, status: :created, location: @lectura
    else
      @lectura = Lectura.new(user_id: user.id, libro_id: params[:libro_id],capitulo_id: params[:capitulo_id], terminado: params[:terminado], deleted: false)
      if @lectura.save
        render json: @lectura, status: :created, location: @lectura
      else
        render json: @lectura.errors, status: :unprocessable_entity
      end
    end
  end


  # DELETE /lecturas/1
  def destroy
    usuario = get_user
    if @lectura.user != usuario && usuario.role != "moderador"
      render json: {error: "Debes ser el propietario para editarlo o tener el rol de moderador."}, status: 401
      return
    end
    @lectura.deleted = true
    if @lectura.save
      render json: {message: "ELiminado con exito"},  status: :ok
    else
      render json: {error: "No se pudo eliminar"}, status: 400
    end
  end

  # GET /capitulo_actual
  def capitulo_actual
    user = get_user
    if user.nil?
      return render json: {error: "El usuario no se encuentra"}, status: 400
    end
    @lectura = Lectura.find_by(user_id: user.id, libro_id: params[:libro_id])

    if @lectura.nil?
      return render json: {error: "No se encuentra el capitulo actual"}, stauts: 404
    end
    capitulo_actual =  @lectura.capitulo_id
    capitulo = Capitulo.find_by(id: capitulo_actual)
    capitulo.contenido = obtener_contenido(capitulo.nombre_archivo)
    return render json: { capitulo_actual: CapituloSerializer.new(capitulo)}, status: 200
  end

  # GET /libros_en_progreso
  def libros_en_progreso
    user = get_user
    if user.nil?
      render json: {error: "El usuario no se encuentra"}, status: 400
      return
    end

    @libros_en_progreso = Libro.joins(:lecturas)
                               .where(lecturas: { user_id: user.id, terminado: false , deleted: false})
                               .order(updated_at: :desc)
                               .distinct
                               .paginate(page: params[:page])
    @libros_en_progreso.each do |libro|
      libro.portada = obtener_portada(libro.portada)
    end

    render json: @libros_en_progreso, status: 200
  end

  def libros_con_capitulos_no_publicados
    user = get_user
    if user.nil?
      render json: {error: "El usuario no se encuentra"}, status: 400
      return
    end
    # Encuentra todos los libros del usuario actual que tienen al menos un capítulo no publicado
    libros = user.libros.includes(:capitulos).where(capitulos: { publicado: false }).distinct.paginate(page: params[:page])

    # Itera sobre cada libro para encontrar el último capítulo no publicado actualizado más recientemente
    libros_con_ultimo_capitulo_no_publicado = libros.map do |libro|
      ultimo_capitulo_no_publicado = libro.capitulos.where(publicado: false).order(updated_at: :desc).first
      ultimo_capitulo_no_publicado.contenido = obtener_contenido(ultimo_capitulo_no_publicado.nombre_archivo)
      capitulo = CapituloForOwnerSerializer.new(ultimo_capitulo_no_publicado)

      libro.portada = obtener_portada(libro.portada)
      libro = LibroSerializer.new(libro)
      { libro: libro, ultimo_capitulo_no_publicado: capitulo }
    end
    render json: libros_con_ultimo_capitulo_no_publicado, status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lectura
      @lectura = Lectura.find(params[:id])
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
    # Only allow a list of trusted parameters through.
    def lectura_params
      params.require(:lectura).permit(:user_id, :libro_id, :capitulo_id, :terminado)
    end
end
