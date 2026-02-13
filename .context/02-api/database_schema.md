// Use DBML to define your database structure
// Project: Circuit Copilot (Accessibilitat + Temps Real)
// Docs: https://dbml.dbdiagram.io/docs

// ---------------------------------------------------------
// ENUMS (Tipus de dades personalitzats)
// ---------------------------------------------------------

// Defineix les dificultats de l'usuari per moure's
Enum mobility_profile {
  standard           // Sense restriccions
  wheelchair         // Cadira de rodes (evitar escales, pendents forts)
  reduced_mobility   // Gent gran, lesions (minimitzar distància)
  visual_impairment  // Visió reduïda (guiat per veu)
  family_stroller    // Cotxets de nadó
}

Enum poi_type {
  restaurant
  wc
  grandstand       // Tribuna
  gate             // Porta d'accés
  medical
  shop
  parking
  meetup_point     // Punts de trobada
}

Enum crowd_level {
  low              // Fluid
  moderate
  high             // Dens
  blocked          // Col·lapsat (activa rerouting automàtic #19)
}

Enum surface_type {
  asphalt
  grass
  gravel
  stairs
  ramp
}

// ---------------------------------------------------------
// TAULES PRINCIPALS (Usuaris i Perfils)
// ---------------------------------------------------------

Table users {
  id integer [primary key, increment]
  email varchar [unique, not null]
  password_hash varchar [not null]
  full_name varchar
  // EL PERFIL DE DIFICULTAT
  mobility_mode mobility_profile [default: 'standard', note: 'Defineix les restriccions de ruta']
  
  // PREFERÈNCIES DE RUTA
  avoid_stairs boolean [default: false]
  avoid_crowds boolean [default: false, note: 'Si vol evitar aglomeracions (ansietat/mobilitat)']
  avoid_slopes boolean [default: false]
  
  created_at timestamp [default: `now()`]
  
  Note: "L'usuari es defineix per com es mou pel circuit."
}

Table tickets {
  id integer [primary key, increment]
  user_id integer [not null]
  code varchar [unique, note: 'Codi de barres/QR escanejat']
  gate varchar [note: 'Porta d\'accés recomanada']
  zone_name varchar [note: 'Zona o Tribuna']
  seat_row varchar
  seat_number varchar
  seat_location geometry [note: 'Coordenades exactes per a guia AR fins al seient']
  is_active boolean [default: true]
  created_at timestamp
  
  Note: "Vincula l'usuari amb la seva localitat física per a l'Onboarding automàtic"
}

// ---------------------------------------------------------
// MAPA I PUNTS D'INTERÈS (Context Espacial)
// ---------------------------------------------------------

Table points_of_interest {
  id integer [primary key, increment]
  name varchar [not null]
  description text
  type poi_type [not null]
  location geometry [not null, note: 'Lat/Long o PostGIS point']
  
  // ESTAT EN TEMPS REAL
  current_crowd_level crowd_level [default: 'low', note: 'Per avisar de col·lapse i redirigir']
  
  // ACCESSIBILITAT
  is_wheelchair_accessible boolean [default: true]
  has_priority_lane boolean [note: 'Carril ràpid per a mobilitat reduïda']
  
  Note: "Llocs rellevants filtrables segons el mobility_mode de l'usuari"
}

// NOVA TAULA: NECESSÀRIA PER AL CÀLCUL DE RUTES
Table path_segments {
  id integer [primary key]
  start_node geometry
  end_node geometry
  
  // Dades Físiques
  surface surface_type [note: 'Gespa, asfalt, escales...']
  slope_percentage float [note: 'Inclinació del camí']
  has_stairs boolean
  
  // Dades Dinàmiques
  current_crowd_level crowd_level [default: 'low', note: 'Si està blocked, la ruta no passa per aquí']
  
  Note: "Representa els camins del circuit per calcular la ruta òptima"
}

// ---------------------------------------------------------
// SOCIAL I GRUPS (Backlog #13, #35)
// ---------------------------------------------------------

Table groups {
  id integer [primary key, increment]
  name varchar
  invite_code varchar [unique]
  created_by integer [note: 'Admin del grup']
  meeting_point geometry [note: 'Punt de trobada fixat pel grup']
  created_at timestamp
}

Table group_members {
  user_id integer
  group_id integer
  joined_at timestamp
  last_location geometry [note: 'Última ubicació coneguda per compartir en temps real']
  last_updated timestamp
  
  indexes {
    (user_id, group_id) [pk]
  }
}

// ---------------------------------------------------------
// UTILITATS D'USUARI (Backlog #34, #33)
// ---------------------------------------------------------

Table saved_locations {
  id integer [primary key, increment]
  user_id integer
  label varchar [note: 'Ex: El meu cotxe, La meva tenda']
  location geometry
  created_at timestamp
  
  Note: "Per guardar la ubicació del pàrquing o punts personals"
}

Table offline_packages {
  id integer [primary key]
  region_name varchar
  file_url varchar
  version varchar
  size_mb float
  
  Note: "Paquets de mapes per a descàrrega offline"
}

// ---------------------------------------------------------
// RELACIONS (Foreign Keys)
// ---------------------------------------------------------

// Un usuari pot tenir múltiples tiquets
Ref: users.id < tickets.user_id

// Relacions de Grup
Ref: users.id < groups.created_by
Ref: users.id < group_members.user_id
Ref: groups.id < group_members.group_id

// Ubicacions guardades
Ref: users.id < saved_locations.user_id
