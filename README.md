# Aterrizar.com
La idea de este TP es implementar el sistema Backend de la empresa *Aterrizar.com*, que comercializa vuelos a todo el mundo.

El TP va a estar dividido en entregas. Cada una de las entregas del TP irá agregando nuevos casos de uso que vamos a implementar utilizando distintas técnicas y tecnologías de persistencia. La idea es que veamos distintas variantes y aprendamos todas.

La fecha de entrega incluye el trabajo durante ese día. O sea que tienen que entregarlo al final de la clase.

## Entrega #1: Usuarios.
Fecha de Entrega: 28/03

La primera entrega tiene como objetivo implementar el registro de usuarios y el login de los mismos. 

Requerimientos:
* Como usuario quiero poder registrarme cargando mis datos y que quede registrado en el sistema. Cuando el usuario se registra debe enviar un mail al usuario para validar su cuenta. Para eso debe generarse un código de validación que se envía por mail. 
* Como usuario quiero poder validar mi cuenta ingresando mi código de validación.
* Como usuario quiero poder entrar en la aplicación ingresando mi nombre de usuario y contraseña. 
* Como usuario quiero poder cambiar mi contraseña. Se debe validar que la nueva contraseña no sea igual a la anterior.
* Como administrador del sistema quiero que el sistema nunca quede en un estado inválido.

De los usuarios debemos administrar los siguientes datos (además de los que necesitemos por los requerimientos):
* Nombre
* Apellido
* Nombre de Usuario (debe ser unique)
* E-Mail.
* Fecha de Nacimiento.

Para el envió de mails tenemos el siguiente servicio escrito por otro grupo de trabajo:

![Diagrama de clase mailing](https://raw.githubusercontent.com/EPERS-UNQ/rentauto/documentation/EnviadorDeMails.png)

Para la entrega es necesario que se implementen los tests necesarios para probar la funcionalidad expuesta. 
En el caso del `EnviadorDeMails` se debe realizar un mock del mismo y testearlo funcionando y tirando una excepción.

## Entrega #2: Aterrizar.
Checkpoint: 11/04<br />
Fecha de Entrega: 18/04

En esta segunda etapa del proyecto vamos a utilizar Hibernate como ORM. 
Esta entrega tiene como objetivo persistir el modelo de vuelos y asientos e integrar el sistema de búsquedas sobre los vuelos disponibles.

#### Contexto:
* La empresa trabaja con muchas aerolíneas.
* Cada aerolínea tiene un conjunto de vuelos ofertados.
* Cada vuelo está conformado por un conjunto de tramos, o sea si el vuelo es directo tiene un solo tramo y si tiene escalas varios. 
* Cada tramo conoce la totalidad de los asientos.
* Cada tramo tiene un origen, un destino, una hora de llegada y una de salida.
* Cada tramo tiene un precio base asociado .
* Los asientos pueden estar reservados o no, si está reservado conoce al usuario que lo reservo.
* Los asientos tienen categoría, Primera, Business, Turista.
* Cada categoría tiene un factor de precio, que  junto con el precio del tramo,  calcula el precio de una reserva.
* Los usuarios reservan asientos para un determinado tramo, si hacen varios tramos tienen asientos para cada uno de ellos.

#### Requerimientos:
* Como usuario quiero reservar un asiento en un determinado tramo.
* Como usuario quiero reservar un conjunto de asientos, comprando todos o ninguno.
* Como usuario quiero consultar los asientos disponibles para un determinado tramo.
* Como usuario quiero realizar búsquedas sobre los vuelos disponibles.
* Como usuario quiero guardar las búsquedas, guardar una búsquedas implica guardar los criterios y no los resultados. La quiero volver a ejecutar.
* Como usuario quiero que las búsquedas tengan un orden que puede ser:
	* Menor Costo primero
	* Menos Escalas primero
	* Menor Duración primero
* Como usuario quiero poder poner criterios a mis búsquedas:
	* Una Aerolínea
	* Una Categoría de Asiento
	* Fecha de Salida
	* Fecha de Llegada
	* Origen y Destino
* Como usuario quiero poder combinar los criterios con operadores OR y AND.

## Entrega #3: Performance en Hibernate.
Fecha de Entrega: 02/05

Ver el enunciado que se encuentra separado aca: https://github.com/EPERS-UNQ/TP-Performance 

## Entrega #4: Amigos
Fecha de Entrega: 16/05

La empresa desea integrar una red social a su sitio de alquiler de autos. En esta red social el usuario, inicialmente, va a tener una cantidad de amigos

#### Requerimientos:
* Como usuario quiero poder agregar a mis amigos que ya son miembro del sitio.
* Como usuario quiero poder consultar a mis amigos
* Como usuario quiero poder mandar mensajes a mis amigos.
* Como usuario quiero poder saber todas las personas con las que estoy conectado, o sea mis amigos y los amigos de mis amigos recursivamente.

El objetivo de esta entrega es implementar los requerimientos utilizando una base de datos orientada a grafos.

## Entrega #5: Comentarios
Fecha de Entrega: 30/05

El objetivo de esta entrega es que el usuario pueda agregar información a su perfil personal.

#### Requerimientos:
* Como usuario quiero poder agregar destinos a los que fui.
* Como usuario quiero a cada destino poder hacerle comentarios, establecer “Me Gusta” o “No me gusta”
* Como usuario quiero a cada destino y comentario establecerle un nivel de visibilidad, privado, público y solo amigos.
* Como usuario quiero poder ver el perfil público de otro usuario, viendo lo que me corresponde según si soy amigo o no.

El objetivo de esta entrega es implementar estos requerimientos utilizando una base de datos orientada a documentos.

## Entrega #6: Cache
Fecha de Entrega: 13/06

#### Requerimientos:
* Como usuario quiero poder cargar fotos y que estas se puedan ver en mi perfil público.
* Como usuario quiero establecer niveles de visibilidad para las fotos, igual que los comentarios.
* Como administrador quiero que los perfiles públicos se guarde en un caché y se consulten solamente de este.
* Como administrador quiero que los perfiles se actualicen en el caché cuando ocurra un cambio.
* Como usuario quiero poder cargar fotos y que estas se puedan ver en mi perfil público.
* Como usuario quiero establecer niveles de visibilidad para las fotos, igual que los comentarios.
* Como administrador quiero que los perfiles públicos se guarde en un caché y se consulten solamente de este.
* Como administrador quiero que los perfiles se actualicen en el caché cuando ocurra un cambio.

El objetivo de esta entrega es implementar los requerimientos utilizando una base de datos orientada a clave/valor.