require 'test_helper'

class RoomTest < ActiveSupport::TestCase

  test "should save if there is a name defined" do
  	r = Room.create(:name => "hola-mundo")
    assert_equal(r.name, "hola-mundo")
  end

  test "should save with random name if there isn't one defined" do
  	assert_equal(Room.all.count, 2)
	r = Room.create
    assert_equal(Room.all.count, 3)
  end

end
