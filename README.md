# README

## Read.me Application Backend

Este README proporciona información sobre la configuración, dependencias del sistema, inicialización de la base de datos, ejecución de pruebas y otras instrucciones relacionadas con la aplicación backend de Read.me.

### Versiones

- Ruby: 3.1.4
- Rails: 7.1.3

### Dependencias del Sistema

Asegúrate de tener instalado Ruby 3.1.4 y Rails 7.1.3 en tu sistema.

### Configuración

No se requiere configuración adicional para ejecutar la aplicación en este momento.

### Creación de la Base de Datos

Ejecuta los siguientes comandos en tu terminal:

- rails db:create
- rails db:migrate

### Migración de la Base de Datos para Pruebas

- Linux: RAILS_ENV=test rails db:migrate
- Windows: rails db:migrate RAILS_ENV=test

### Inicialización de la Base de Datos

No se requiere inicialización adicional de la base de datos en este momento.

### Ejecución de las Pruebas

Utiliza alguno de los siguientes comandos:

- rails server
- rails s

### Servicios

No hay servicios adicionales requeridos para el funcionamiento de la aplicación en este momento.

### Instrucciones de Implementación

Las instrucciones para implementar esta aplicación en un entorno de producción aún están por definirse.

### Puerto Predeterminado (puma.rb)

El puerto predeterminado para esta aplicación es 4000.

### Más Información

Para más detalles sobre la configuración y funcionamiento de la aplicación, consulta la documentación interna o ponte en contacto con el equipo de desarrollo.

Este README puede ser actualizado con información adicional según sea necesario.
