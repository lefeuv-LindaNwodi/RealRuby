class GameWindow < Hasu::Window
  SPRITE_SIZE = 128
  SPRITE_SIZE2 = 700
  WINDOW_X = 1280
  WINDOW_Y = 720

  def initialize
    super(WINDOW_X, WINDOW_Y, false)
    @background_sprite = Gosu::Image.new(self, 'images/background.png', true)
    @koala_sprite = Gosu::Image.new(self, 'images/goku2.png', true)
    enemy_tab
    @enemy_sprite = Gosu::Image.new(self, 'images/Freezer.png', true)
    @flag_sprite = Gosu::Image.new(self, 'images/DB.png', true)
    @font = Gosu::Font.new(self, Gosu::default_font_name, 30)
    @flag = {x: WINDOW_X - SPRITE_SIZE, y: WINDOW_Y - SPRITE_SIZE2}
    @win_img = Gosu::Image.new(self,"images/shenron.png", true)
    # @music = Gosu::Song.new(self, "musics/Chala-head-Chala.wav")
    reset
    @cont = 0
    @i = 0
  end

  def enemy_tab
    @enemy_sprite_tab = []
    @enemy_sprite_tab.push(Gosu::Image.new(self, 'images/Freezer.png', true))
    @enemy_sprite_tab.push(Gosu::Image.new(self, 'images/buu.png', true))
    @enemy_sprite_tab.push(Gosu::Image.new(self, 'images/cell.png', true))
    @enemy_sprite_tab.push(Gosu::Image.new(self, 'images/beerus.png', true))
  end

  def update
    if @enemies.length >= 3 && @enemies.length < 5
      @koala_sprite = @koala_sprite = Gosu::Image.new(self, 'images/gokuSS2.png', true)
    elsif @enemies.length >= 5
      @koala_sprite = @koala_sprite = Gosu::Image.new(self, 'images/gokugod.png', true)
      
    end
    @player[:x] += @speed if button_down?(Gosu::Button::KbRight)
    @player[:x] -= @speed if button_down?(Gosu::Button::KbLeft)
    @player[:y] += @speed if button_down?(Gosu::Button::KbDown)
    @player[:y] -= @speed if button_down?(Gosu::Button::KbUp)
    @player[:x] = normalize(@player[:x], WINDOW_X - SPRITE_SIZE)
    @player[:y] = normalize(@player[:y], WINDOW_Y - SPRITE_SIZE)
    @player[:y] += 3
    handle_enemies
    handle_enemies2
    handle_quit
    if winning?
      # if @cont == 0
      #   @enemy_sprite = Gosu::Image.new(self, 'images/buu.png', true)
      #   @cont += 1
      # elsif @cont == 1
      #   @enemy_sprite = Gosu::Image.new(self, 'images/cell.png', true)
      #   @cont += 1
      # elsif @cont == 2
      #   @enemy_sprite = Gosu::Image.new(self, 'images/cell.png', true)
      #   @cont += 1
      # elsif @cont == 3
      #   @enemy_sprite = Gosu::Image.new(self, 'images/beerus.png', true)
      #   @cont += 1
      # elsif @cont == 4
      #   @enemy_sprite = Gosu::Image.new(self, 'images/Freezer.png', true)
      #   @cont = 0
      # end
      
      reinit
    end
    # if loosing?
    #   reset
    # end
  end



  def draw
    @font.draw("Level #{@enemies.length}", WINDOW_X - WINDOW_X + 10, 10, 3, 1.0, 1.0, Gosu::Color::WHITE)
    if @enemies.length == 8
      @font.draw("Vous avez trouvé les 7 boules de christal !!!!", 100, 650, 4, 2, 2, Gosu::Color::WHITE)
      @win_img.draw(160, 20, 3)
    end

    @koala_sprite.draw(@player[:x], @player[:y], 2)

    @aaa = @enemies[0]
    @enemy_sprite_tab[0].draw(@aaa[:x], @aaa[:y], 2)
    @aaaa = @enemies[1]
    @enemy_sprite_tab[1].draw(@aaaa[:x], @aaaa[:y], 2) if @enemies.length >= 2
    @aaaaa = @enemies[2]
    @enemy_sprite_tab[2].draw(@aaaaa[:x], @aaaaa[:y], 2) if @enemies.length >= 3
    @aaab = @enemies[3]
    @enemy_sprite_tab[3].draw(@aaab[:x], @aaab[:y], 2) if @enemies.length >= 4
    @aaaac = @enemies[4]
    @enemy_sprite_tab[0].draw(@aaaac[:x], @aaaac[:y], 2) if @enemies.length >= 5
    @aaaad = @enemies[5]
    @enemy_sprite_tab[1].draw(@aaaad[:x], @aaaad[:y], 2) if @enemies.length >= 6
    @ad = @enemies[6]
    @enemy_sprite_tab[2].draw(@ad[:x], @ad[:y], 2) if @enemies.length >= 7
    @c = @enemies[7]
    @enemy_sprite_tab[3].draw(@c[:x], @c[:y], 2) if @enemies.length >= 8


    @flag_sprite.draw(@flag[:x], @flag[:y], 1)
    (0..8).each do |x|
      (0..8).each do |y|
        @background_sprite.draw(x * SPRITE_SIZE, y * SPRITE_SIZE, 0)
      end
    end
  end

  private



  def reset
    @high_score = 0
    @enemies = []
    @enemies2 = []
    @speed = 8
    if @music
      @music.stop
      @music.play
    end
    reinit
  end

  def reinit
    @speed += 1
    @player = {x: 000, y: 700}

    #@enemies = @add_enemy

    @enemies.push({ x: WINDOW_X + rand(100), y: WINDOW_Y + rand(100)})
    @enemies2.push({ x: WINDOW_X + rand(100), y: WINDOW_Y + rand(100)})
    # @mechant.push(Mechant.new(50, 100))
    high_score
  end

  def high_score
    unless File.exist?('hiscore')
      File.new('hiscore', 'w')
    end
    @new_high_score = [@enemies.count, File.read('hiscore').to_i].max
    File.write('hiscore', @new_high_score)
  end

  def collision?(a, b)
    (a[:x] - b[:x]).abs < SPRITE_SIZE / 2 &&
    (a[:y] - b[:y]).abs < SPRITE_SIZE / 2
  end

  def loosing?
    @enemies.any? do |enemy|
      collision?(@player, enemy)
    end
  end

  def winning?
    collision?(@player, @flag)
  end



  def random_mouvement
    (rand(3) - 1)
  end

  def normalize(v, max)
    if v < 0
      0
    elsif v > max
      max
    else
      v
    end
  end

  def handle_quit
    if button_down? Gosu::KbEscape
      close
    end
  end

  def handle_enemies
    @enemies = @enemies.map do |enemy|
      enemy[:timer] ||= 0
      if enemy[:timer] == 0
        enemy[:result_x] = random_mouvement
        enemy[:result_y] = random_mouvement
        enemy[:timer] = 50 + rand(50)
      end
      enemy[:timer] -= 1


      new_enemy = enemy.dup
      new_enemy[:x] += new_enemy[:result_x] * @speed
      new_enemy[:y] += new_enemy[:result_y] * @speed
      new_enemy[:x] = normalize(new_enemy[:x], WINDOW_X - SPRITE_SIZE)
      new_enemy[:y] = normalize(new_enemy[:y], WINDOW_Y - SPRITE_SIZE)
      unless collision?(new_enemy, @flag)
        enemy = new_enemy
      end
      enemy
    end
  end
    def handle_enemies2
    @enemies2 = @enemies2.map do |enemy|
      enemy[:timer] ||= 0
      if enemy[:timer] == 0
        enemy[:result_x] = random_mouvement
        enemy[:result_y] = random_mouvement
        enemy[:timer] = 50 + rand(50)
      end
      enemy[:timer] -= 1

      new_enemy = enemy.dup
      new_enemy[:x] += new_enemy[:result_x] * @speed
      new_enemy[:y] += new_enemy[:result_y] * @speed
      new_enemy[:x] = normalize(new_enemy[:x], WINDOW_X - SPRITE_SIZE)
      new_enemy[:y] = normalize(new_enemy[:y], WINDOW_Y - SPRITE_SIZE)
      unless collision?(new_enemy, @flag)
        enemy = new_enemy
      end
      enemy
    end
  end
end



