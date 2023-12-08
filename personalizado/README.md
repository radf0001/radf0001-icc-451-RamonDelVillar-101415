# Descripción General

La aplicación Pokedex proporciona una interfaz interactiva para explorar y buscar información sobre Pokémon. Utiliza la API de PokeAPI para recuperar datos y presentarlos en un formato amigable para el usuario. Los usuarios pueden ver listados de Pokémon, buscar por nombre, y ver detalles específicos como estadísticas, movimientos y evoluciones.
 Estructura del Proyecto

El proyecto está estructurado en varias carpetas y archivos principales:
- `lib/`: Carpeta principal que contiene el código fuente de Dart.
  - `fonts/`: Fuentes utilizadas en la aplicacion.
  - `images/`: Contiene las imágenes de la interfaz de usuario.
  - `models/`: Define las estructuras de datos utilizadas en la aplicación.
  - `screens/`: Contiene los archivos de la interfaz de usuario.
  - `utils/`: Componente para desplazar hacia el inicio de la pokedex.
  - `services/`: Servicios para realizar llamadas HTTP a la API y manejar el almacenamiento local.
  - `widgets/`: Componentes de UI reutilizables.
Uso de la API

La aplicación hace uso de la [PokeAPI](https://pokeapi.co/) para obtener la información de los Pokémon. Se realizan llamadas GET para obtener los datos que luego son deserializados en modelos definidos en la aplicación.

## Endpoints Utilizados

- `/pokemon`: Recupera información básica de todos los Pokémon.
- `/pokemon/{id}`: Obtiene detalles específicos de un Pokémon por su ID.
- `/evolution-chain/{id}`: Recupera la cadena evolutiva de un Pokémon específico.
- `/type/{type}`: En el código, se utiliza una URL como https://pokeapi.co/api/v2/type/$filter para obtener datos de Pokémon de un tipo específico. Esto corresponde al endpoint para recuperar información sobre un tipo de Pokémon en particular.
- `/pokemon?limit={limit}`: En el código, se usa la URL como https://pokeapi.co/api/v2/pokemon?limit=$limit para obtener una lista de Pokémon con un límite específico. Esto se utiliza para cargar inicialmente una cantidad limitada de Pokémon en la pantalla de inicio.
- `/ability/{name}`: Este endpoint se utiliza para obtener información sobre una habilidad de Pokémon específica. La pantalla SearchedAbilityScreen recibe el nombre de la habilidad como argumento y realiza una solicitud a la API de Pokémon para obtener detalles sobre esa habilidad.
- `/pokemon/{id}`: Este endpoint se utiliza para obtener detalles específicos de un Pokémon por su ID. En la pantalla PokemonDetailScreen, se utiliza para mostrar información detallada sobre un Pokémon específico. La URL se forma utilizando el ID del Pokémon.

## Librerías Principales Utilizadas

- `http`: Para realizar solicitudes HTTP a la API de PokeAPI.
- `flutter_screenutil`: Proporciona herramientas para hacer que la UI sea responsiva y adaptable a diferentes tamaños de pantalla.
- `cached_network_image`: Utilizada para cargar y almacenar en caché imágenes de la red.
- `flutter_share`: Permite compartir contenido a través de otras aplicaciones instaladas en el dispositivo.

## Características

- Listado de Pokémon: Muestra un grid de tarjetas con la imagen y el nombre de cada Pokémon.
- Búsqueda de Pokémon: Permite a los usuarios buscar Pokémon por nombre.
- Detalle de Pokémon: Al seleccionar un Pokémon, se muestra una pantalla con más detalles como sus estadísticas, movimientos, habilidades y evoluciones.
- Favoritos: Los usuarios pueden marcar a los Pokémon como favoritos y ver una lista filtrada de sus favoritos.
- Compartir: Los usuarios pueden compartir detalles de Pokémon específicos con otros.
## Problemas Conocidos y Soluciones

- Desbordamiento de texto: Se utilizó el widget `FittedBox` para asegurar que el texto se ajuste dentro de los widgets sin desbordarse.
-Imágenes de fondo: Se creó un widget personalizado para manejar las imágenes de fondo que representan los tipos de Pokémon.
-Responsividad: Se empleó `flutter_screenutil` para asegurar que la aplicación se vea y funcione bien en una variedad de tamaños de pantalla.
