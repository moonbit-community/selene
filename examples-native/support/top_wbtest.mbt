///|
test "native support resolves shared example asset paths" {
  inspect(
    read_example_asset("survivors", "assets/survivors/enemy/Orc.png") is Some(_),
    content="true",
  )
  inspect(
    read_example_asset(
      "pixeladventure", "assets/pixeladventure/Enemies/BlueBird/Hit (32x32).png",
    )
    is Some(_),
    content="true",
  )
  inspect(
    read_example_asset("pixeladventure", "selene.project.json") is Some(_),
    content="true",
  )
}
