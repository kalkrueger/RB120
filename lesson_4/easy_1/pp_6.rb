class Cube
  attr_reader :volume

  def initialize(volume)
    @volume = volume
  end
end

brick = Cube.new(120)
p brick.volume
