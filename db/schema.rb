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

ActiveRecord::Schema[7.1].define(version: 2024_02_24_152936) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "capitulos", force: :cascade do |t|
    t.bigint "libro_id", null: false
    t.string "titulo"
    t.string "nombre_archivo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "previous_capitulo"
    t.bigint "next_capitulo"
    t.boolean "deleted", default: false
    t.index ["libro_id"], name: "index_capitulos_on_libro_id"
  end

  create_table "comentarios", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "libro_id", null: false
    t.text "comentario"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted", default: false
    t.index ["libro_id"], name: "index_comentarios_on_libro_id"
    t.index ["user_id"], name: "index_comentarios_on_user_id"
  end

  create_table "favoritos", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "libro_id", null: false
    t.boolean "favorito"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted", default: false
    t.index ["libro_id"], name: "index_favoritos_on_libro_id"
    t.index ["user_id"], name: "index_favoritos_on_user_id"
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
    t.index ["user_id"], name: "index_libros_on_user_id"
  end

  create_table "reportes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "libro_id", null: false
    t.string "motivo"
    t.string "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted", default: false
    t.index ["libro_id"], name: "index_reportes_on_libro_id"
    t.index ["user_id"], name: "index_reportes_on_user_id"
  end

  create_table "resenhas", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "libro_id", null: false
    t.integer "puntuacion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted", default: false
    t.index ["libro_id"], name: "index_resenhas_on_libro_id"
    t.index ["user_id"], name: "index_resenhas_on_user_id"
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

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted", default: false
    t.date "fecha_nacimiento"
  end

  add_foreign_key "capitulos", "capitulos", column: "next_capitulo"
  add_foreign_key "capitulos", "capitulos", column: "previous_capitulo"
  add_foreign_key "capitulos", "libros"
  add_foreign_key "comentarios", "libros"
  add_foreign_key "comentarios", "users"
  add_foreign_key "favoritos", "libros"
  add_foreign_key "favoritos", "users"
  add_foreign_key "libros", "users"
  add_foreign_key "reportes", "libros"
  add_foreign_key "reportes", "users"
  add_foreign_key "resenhas", "libros"
  add_foreign_key "resenhas", "users"
  add_foreign_key "total_resenhas", "libros"
end
