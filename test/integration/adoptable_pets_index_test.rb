require "test_helper"

class AdoptablePetsIndexTest < ActionDispatch::IntegrationTest
  # all unadopted pets under all organizations
  setup do
    @pet_count = Pet.includes(:match).where(match: {id: nil}).length
  end

  test "unauthenticated user can access adoptable pets index" do
    get "/adoptable_pets"
    assert_response :success
    assert_select "h1", "Up for adoption"
  end

  test "all unadopted pets show on the pet_index page" do
    get "/adoptable_pets"
    assert_select "img.card-img-top", {count: @pet_count}
  end

  test "pet name shows adoption pending if it has any applications with that status" do
    get "/adoptable_pets"
    assert_select "h3", "#{pets(:pending_adoption_one).name} (Adoption Pending)"
  end
end
