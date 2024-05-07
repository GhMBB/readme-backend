# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_05_06_222437) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "book_report_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "capitulos", force: :cascade do |t|
    t.bigint "libro_id", null: false
    t.string "titulo"
    t.string "nombre_archivo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted", default: false
    t.integer "indice"
    t.boolean "publicado"
    t.index ["libro_id"], name: "index_capitulos_on_libro_id"
  end

  create_table "comentarios", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "libro_id", null: false
    t.text "comentario"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted", default: false
    t.boolean "deleted_by_user"
    t.index ["libro_id"], name: "index_comentarios_on_libro_id"
    t.index ["user_id"], name: "index_comentarios_on_user_id"
  end

  create_table "comment_report_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favoritos", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "libro_id", null: false
    t.boolean "favorito"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted", default: false
    t.boolean "deleted_by_user"
    t.index ["libro_id"], name: "index_favoritos_on_libro_id"
    t.index ["user_id"], name: "index_favoritos_on_user_id"
  end

  create_table "fecha_lecturas", force: :cascade do |t|
    t.bigint "lectura_id"
    t.date "fecha"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "libro_id", null: false
    t.index ["lectura_id"], name: "index_fecha_lecturas_on_lectura_id"
    t.index ["libro_id"], name: "index_fecha_lecturas_on_libro_id"
    t.index ["user_id"], name: "index_fecha_lecturas_on_user_id"
  end

  create_table "lecturas", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "libro_id", null: false
    t.date "fecha"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted"
    t.boolean "terminado"
    t.bigint "capitulo_id", null: false
    t.boolean "leido"
    t.boolean "deleted_by_user"
    t.index ["capitulo_id"], name: "index_lecturas_on_capitulo_id"
    t.index ["libro_id"], name: "index_lecturas_on_libro_id"
    t.index ["user_id"], name: "index_lecturas_on_user_id"
  end

  create_table "libros", force: :cascade do |t|
    t.string "titulo"
    t.text "sinopsis"
    t.string "portada"
    t.boolean "adulto"
    t.float "puntuacion_media"
    t.integer "cantidad_comentarios"
    t.string "portada_url"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted", default: false
    t.string "categoria"
    t.integer "cantidad_lecturas"
    t.integer "cantidad_resenhas"
    t.integer "sumatoria"
    t.boolean "deleted_by_user"
    t.index ["user_id"], name: "index_libros_on_user_id"
  end

  create_table "personas", force: :cascade do |t|
    t.date "fecha_de_nacimiento"
    t.string "profile"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "descripcion"
    t.string "nacionalidad"
    t.string "direccion"
    t.string "email"
    t.string "portada"
    t.string "nombre"
    t.boolean "baneado"
    t.date "fecha_eliminacion"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "email_confirmed"
    t.index ["user_id"], name: "index_personas_on_user_id"
  end

  create_table "reportes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "libro_id"
    t.string "motivo"
    t.string "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted", default: false
    t.string "categoria"
    t.bigint "comentario_id"
    t.bigint "usuario_reportado_id"
    t.text "conclusion"
    t.bigint "moderador_id"
    t.boolean "deleted_by_user"
    t.index ["comentario_id"], name: "index_reportes_on_comentario_id"
    t.index ["libro_id"], name: "index_reportes_on_libro_id"
    t.index ["moderador_id"], name: "index_reportes_on_moderador_id"
    t.index ["user_id"], name: "index_reportes_on_user_id"
    t.index ["usuario_reportado_id"], name: "index_reportes_on_usuario_reportado_id"
  end

  create_table "resenhas", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "libro_id"
    t.integer "puntuacion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted", default: false
    t.boolean "deleted_by_user"
    t.index ["libro_id"], name: "index_resenhas_on_libro_id"
    t.index ["user_id"], name: "index_resenhas_on_user_id"
  end

  create_table "seguidors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "follower_id"
    t.bigint "followed_id"
    t.boolean "deleted"
    t.index ["followed_id"], name: "index_seguidors_on_followed_id"
    t.index ["follower_id"], name: "index_seguidors_on_follower_id"
  end

  create_table "solicitud_desbaneos", force: :cascade do |t|
    t.bigint "baneado_id", null: false
    t.string "justificacion"
    t.string "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted"
    t.index ["baneado_id"], name: "index_solicitud_desbaneos_on_baneado_id"
  end

  create_table "total_resenhas", force: :cascade do |t|
    t.bigint "libro_id", null: false
    t.integer "cantidad"
    t.integer "sumatoria"
    t.float "media"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted", default: false
    t.index ["libro_id"], name: "index_total_resenhas_on_libro_id"
  end

  create_table "user_report_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted", default: false
    t.date "fecha_nacimiento"
    t.string "profile"
    t.string "email"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
  end

  add_foreign_key "capitulos", "libros"
  add_foreign_key "comentarios", "libros"
  add_foreign_key "comentarios", "users"
  add_foreign_key "favoritos", "libros"
  add_foreign_key "favoritos", "users"
  add_foreign_key "fecha_lecturas", "lecturas"
  add_foreign_key "fecha_lecturas", "libros"
  add_foreign_key "fecha_lecturas", "users"
  add_foreign_key "lecturas", "capitulos"
  add_foreign_key "lecturas", "libros"
  add_foreign_key "lecturas", "users"
  add_foreign_key "libros", "users"
  add_foreign_key "personas", "users"
  add_foreign_key "reportes", "comentarios"
  add_foreign_key "reportes", "libros"
  add_foreign_key "reportes", "users"
  add_foreign_key "reportes", "users", column: "moderador_id"
  add_foreign_key "reportes", "users", column: "usuario_reportado_id"
  add_foreign_key "resenhas", "libros"
  add_foreign_key "resenhas", "users"
  add_foreign_key "seguidors", "users", column: "followed_id"
  add_foreign_key "seguidors", "users", column: "follower_id"
  add_foreign_key "solicitud_desbaneos", "users", column: "baneado_id"
  add_foreign_key "total_resenhas", "libros"
end
