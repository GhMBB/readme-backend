class LecturasController < ApplicationController
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
      render json: {error: "El usuario no se encuentra"}, status: 400
      return
    end

    @lectura = Lectura.find_by(user_id: user.id, libro_id: params[:libro_id])
    capitulo_actual =  @lectura.capitulo_id
    capitulo = Capitulo.find_by(id: capitulo_actual)
    render json: { capitulo_actual: CapituloSerializer.new(capitulo)}
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

    render json: @libros_en_progreso, status: 200
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lectura
      @lectura = Lectura.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def lectura_params
      params.require(:lectura).permit(:user_id, :libro_id, :capitulo_id, :terminado)
    end
end
