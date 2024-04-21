require 'ruby2d'

require 'i18n'
I18n.available_locales = [:en, :es]
I18n.default_locale= :en

# Define the available words


WORDS = [
  # Animales
  "perro", "gato", "elefante", "león", "tigre", "oso", "jirafa", "mono", "conejo", "ratón",
  "pájaro", "pollo", "pato", "gallina", "cuervo", "búho", "águila", "halcón", "loro", "pavo",
  "caballo", "vaca", "cerdo", "oveja", "cabra", "toro", "burro", "oveja", "ovejita", "canguro",
  # Familia
  "padre", "madre", "hermano", "hermana", "abuelo", "abuela", "tío", "tía", "primo", "prima",
  "sobrino", "sobrina", "hijo", "hija", "niño", "niña", "bebé", "esposo", "esposa", "novio",
  "novia", "compañero", "compañera", "amigo", "amiga", "vecino", "vecina", "jefe", "jefa",
  # Trabajos
  "médico", "enfermero", "maestro", "profesor", "científico", "ingeniero", "abogado", "arquitecto",
  "policía", "bombero", "soldado", "cocinero", "chef", "pintor", "artista", "músico", "cantante",
  "actor", "actriz", "escritor", "poeta", "periodista", "reportero", "electricista", "plomero",
  "mecánico", "plomero", "albañil", "carpintero", "plastiquero", "jardinero", "granjero", "vendedor",
  # Colores
  "rojo", "verde", "azul", "amarillo", "naranja", "violeta", "rosa", "morado", "gris", "blanco",
  "negro", "marrón", "beige", "turquesa", "celeste", "salmon", "crema", "dorado", "plateado",
  "café", "canela", "marfil", "esmeralda", "carmín", "teja", "lavanda", "ámbar", "aguamarina",
  # Vehículos
  "carro", "auto", "camión", "bus", "bicicleta", "motocicleta", "avión", "helicóptero", "barco",
  "yate", "velero", "tren", "tranvía", "metro", "taxi", "furgoneta", "camioneta", "ambulancia",
  "patrulla", "moto", "coche", "trailer", "tren", "bicicleta", "patineta", "carreta", "triciclo",
  "tractor", "excavadora", "grúa", "submarino", "dirigible", "caravana", "lancha", "jet",
].map(&:upcase)

# Initialize the window
set(title: "Word Guessing Game", width: Window.display_width, height: Window.display_height)

# Define the game class
class Game
  attr_reader :current_word, :current_letter_index

  def initialize
    @current_word = WORDS.sample
    @current_letter_index = 0
    @success_sound = Sound.new('assets/success.wav')
    @failure_sound = Sound.new('assets/failure.wav')
    @clapping_sound = Sound.new('assets/clapping.wav')
  end

  def show_word
    x = 20
    y = 150
    size = 100
    @current_word.chars.map.with_index do |char, index|
      x += size
      Text.new(
        char,
        x:,
        y:,
        size:,
        color: char_color(index)
      )
    end
  end

  def char_color(index)
   return 'green' if index < @current_letter_index
   return 'red' if index == @current_letter_index
   'yellow'
  end

  def update_current_letter
    @current_letter_index += 1
  end

  def check_letter(key)
    if i18n_equal?(key, @current_word[@current_letter_index])
      @success_sound.play
      @current_letter_index += 1
      return true
    else
      @failure_sound.play
      return false
    end
  end

  def i18n_equal?(a,b)
    puts "comparing #{a} with #{b}"
    I18n.transliterate(a).upcase == I18n.transliterate(b).upcase
  end

  def restart_game
    @clapping_sound.play
    @current_word = WORDS.sample
    @current_letter_index = 0
  end
end

# Initialize the game
game = Game.new
word_text = game.show_word

# Keyboard event handler
on :key_down do |event|
  if event.key.length == 1 # Check if it's a valid key
    if game.check_letter(event.key)
      word_text.map(&:remove)
      word_text = game.show_word
      if game.current_letter_index >= game.current_word.length
        game.restart_game
        word_text.map(&:remove)
        word_text = game.show_word
      end
    end
  end
end

show
