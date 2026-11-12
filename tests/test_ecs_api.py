"""Compile an external consumer to verify the ECS encapsulation boundary."""

import json
import re
import subprocess
import tempfile
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
COMPONENT = """
pub(all) struct Position(Int)
let position_key : @ecs.ComponentKey[Position] = ComponentKey()
impl @ecs.Component for Position with component_key() { position_key }
"""


class EcsPublicApiTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.workspace = tempfile.TemporaryDirectory(prefix="selene-ecs-api-")
        cls.addClassCleanup(cls.workspace.cleanup)
        root = Path(cls.workspace.name)
        cls.consumer = root / "consumer"
        cls.consumer.mkdir()
        (root / "moon.work").write_text(
            "members = " + json.dumps([str(REPO / "selene-core"), "./consumer"])
        )
        version = re.search(
            r'^version = "([^"]+)"',
            (REPO / "selene-core/moon.mod").read_text(),
            re.MULTILINE,
        ).group(1)
        (cls.consumer / "moon.mod").write_text(
            'name = "selene/api-test"\n'
            f'import {{ "Milky2018/selene@{version}" }}\n'
        )
        (cls.consumer / "moon.pkg").write_text(
            'import { "Milky2018/selene/ecs" }\n'
        )

    def compile(self, body):
        (self.consumer / "access.mbt").write_text(
            COMPONENT + "\npub fn exercise(world : @ecs.World) -> Unit {\n"
            + body + "\n}\n"
        )
        return subprocess.run(
            ["moon", "check", "--target", "wasm", "--no-mbti", "--output-json",
             "--deny-warn", "--warn-list", "+73"],
            cwd=self.consumer, capture_output=True, text=True, timeout=120,
        )

    def test_world_and_query_access_compiles(self):
        result = self.compile("""
  let entity = world.spawn1(Position(1))
  let query : @ecs.Query[Position] = world.query()
  world.set_component(entity, Position(2))
  ignore(query.get(entity))
  let pair : @ecs.Query2[Position, Position] = world.query2()
  pair.for_each((_, _, _) => ())
  let draft = world.spawn_draft()
  draft.add(Position(3))
  ignore(draft.spawn())
""")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_storage_access_is_rejected_outside_ecs(self):
        cases = {
            "component_store": ('let store : @ecs.ComponentStore[Position] = @ecs.components()\n  ignore(store)', "ComponentStore"),
            "global_components": ("ignore(@ecs.components())", "components"),
            "world_components": ("ignore(@ecs.components_in(world))", "components_in"),
            "key_store": ("ignore(position_key.store_in(world))", "store_in"),
            "key_current_store": ("ignore(position_key.store())", "store"),
            "key_get": ("ignore(position_key.get(world.spawn(())))", "get"),
            "key_set": ("position_key.set(world.spawn(()), Position(1))", "set"),
            "query_storage": ("let query : @ecs.Query[Position] = world.query()\n  ignore(query.storage)", "abstract type"),
            "joined_constructor": ("ignore(@ecs.Query2(world.query(), world.query()))", "Query2"),
            "draft_store": ("world.spawn_draft().add_to(world.query(), Position(1))", "add_to"),
            "store_spawn": ("let query : @ecs.Query[Position] = world.query()\n  ignore(query.spawn_plan(world))", "spawn_plan"),
        }
        for name, (source, symbol) in cases.items():
            with self.subTest(name=name):
                result = self.compile(source)
                output = result.stdout + result.stderr
                self.assertNotEqual(result.returncode, 0, output)
                errors = [json.loads(line) for line in output.splitlines()
                          if line.startswith('{"$message_type":"diagnostic"')]
                self.assertTrue(any(
                    item["level"] == "error" and symbol in item["message"]
                    for item in errors
                ), output)

    def test_structural_changes_are_rejected_in_query_callbacks(self):
        # A fatal abort does not unwind MoonBit defers. Run this contract in a
        # separate process so its query scope cannot affect other tests.
        manifest = self.consumer / "moon.pkg"
        original = manifest.read_text()
        manifest.write_text(original + '\npkgtype(kind: "executable")\n')
        (self.consumer / "access.mbt").write_text(COMPONENT + """
fn main {
  let world = @ecs.World()
  ignore(world.spawn1(Position(1)))
  let query : @ecs.Query[Position] = world.query()
  query.for_each((_, _) => {
    println("entered query callback")
    ignore(world.spawn1(Position(2)))
  })
}
""")
        try:
            result = subprocess.run(
                ["moon", "run", "--target", "wasm", "."], cwd=self.consumer,
                capture_output=True, text=True, timeout=120,
            )
        finally:
            manifest.write_text(original)
        output = result.stdout + result.stderr
        self.assertNotEqual(result.returncode, 0, output)
        self.assertIn("entered query callback", output)
        self.assertIn("queue structural changes outside an archetype query", output)


if __name__ == "__main__":
    unittest.main()
