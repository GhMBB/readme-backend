# frozen_string_literal: true

class Lectura < ApplicationRecord
  belongs_to :user
  belongs_to :libro
  belongs_to :capitulo

  validates :user_id, presence: { message: 'El ID de usuario no puede estar en blanco' }
  validates :libro_id, presence: { message: 'El ID de libro no puede estar en blanco' }
  validates :capitulo_id, presence: { message: 'El ID de capítulo no puede estar en blanco' }

  attribute :deleted, :boolean, default: false
  attribute :terminado, :boolean, default: false
  attribute :leido, :boolean, default: false
  has_many :fecha_lecturas
  # @param [Object] params
  # @param [Object] user
  def self.create_lectura(params, user)
    libro_id = params[:libro_id]
    capitulo_id = params[:capitulo_id]

    if libro_id.blank? || capitulo_id.blank?
      return { error: 'Falta el id del libro o del capitulo' }, :unprocessable_entity
    end

    capitulo = Capitulo.find_by(id: capitulo_id, libro_id:)
    if capitulo.nil?
      return { error: 'El capitulo no pertenece al libro' }, :unprocessable_entity
    elsif capitulo.publicado == false && capitulo.libro.user_id != user.id
      return { error: 'El capitulo no está disponible' }, :unprocessable_entity
    end

    leyendo = Lectura.find_by(libro_id:, user_id: user.id)
    leido = params[:leido]
    if leyendo.present?
      if leido.nil?
        leyendo.update(capitulo_id:, terminado: params[:terminado], deleted: false)
      else
        leyendo.update(capitulo_id:, terminado: params[:terminado], leido: params[:leido], deleted: false)
      end

      [{ message: 'Progreso de lectura actualizado exitosamente',
         lectura: LecturaSerializer.new(leyendo) }, :created]
    else
      lectura = if leido.nil?
                  Lectura.new(user_id: user.id, libro_id:, capitulo_id:,
                              terminado: params[:terminado], deleted: false)
                else
                  Lectura.new(user_id: user.id, libro_id:, capitulo_id:,
                              terminado: params[:terminado], leido: params[:leido], deleted: false)
                end
      if lectura.save
        [{ message: 'Lectura creada exitosamente', lectura: LecturaSerializer.new(leyendo) }, :created]
      else
        [{ errors: lectura.errors.full_messages }, :unprocessable_entity]
      end
    end
  end

  # @return [[Hash{Symbol->String (frozen)}, Integer]]
  def self.crear_fecha_lectura(params, user)
    libro_id = params[:libro_id]
    fecha_lectura = FechaLectura.new(user_id: user.id, libro_id:, fecha: Time.now)
    if fecha_lectura.save
      [{ message: 'Guardado con exito' }, 200]
    else
      [{ errors: 'No se pudo guardar' }, 400]
    end
  end

  def self.current_chapter(params, user)
    lectura = Lectura.find_by(user_id: user.id, libro_id: params[:libro_id])
    return { error: 'No se encuentra el capitulo actual' }, :ok if lectura.nil?
    capitulo_actual = lectura.capitulo_id
    capitulo = Capitulo.find_by(id: capitulo_actual)
    if capitulo.libro.user == user
      [{ capitulo_actual: CapituloForOwnerSerializer.new(capitulo) }, :ok]
    else
      [{ capitulo_actual: CapituloForViwerSerializer.new(capitulo) }, :ok]
    end
  end
end
