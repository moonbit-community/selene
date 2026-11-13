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

    def compile(self, body, *, strict=True):
        (self.consumer / "access.mbt").write_text(
            COMPONENT + "\npub fn exercise(world : @ecs.World) -> Unit {\n"
            + body + "\n}\n"
        )
        return subprocess.run(
            ["moon", "check", "--target", "wasm", "--no-mbti", "--output-json",
             *(["--deny-warn", "--warn-list", "+73"] if strict else [])],
            cwd=self.consumer, capture_output=True, text=True, timeout=120,
        )

    def test_world_and_query_access_compiles(self):
        result = self.compile("""
  let commands = @ecs.commands(world)
  let entity = commands.spawn1(Position(1))
  let query : @ecs.Query[@ecs.Single[Position]] = world.query()
  commands.add(world => world.set_component(entity, Position(2)))
  ignore(query.get(entity))
  query.set(entity, Single(Position(4)))
  let pair : @ecs.Query[(Position, Position)] = world.query()
  for _, _ in pair {}
  let draft = @ecs.commands(world).draft()
  draft.add(Position(3))
  ignore(commands.spawn_draft(draft))
  try! @ecs.Schedule().add_exclusive_system(world => {
    ignore(world.id())
    commands.delete(entity)
  }).run(world)
""")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_system_parameter_registration_compiles(self):
        manifest = self.consumer / "moon.pkg"
        original = manifest.read_text()
        manifest.write_text(original + '\nimport { "Milky2018/selene/app" }\n')
        try:
            result = self.compile("""
  fn move_entities(query : @ecs.Query[(Position, Position)]) -> Unit {
    for _, _ in query {}
  }
  ignore(@app.App().with_world(world).add_system(Update, move_entities))
""")
        finally:
            manifest.write_text(original)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_execution_internals_are_not_public(self):
        manifest = self.consumer / "moon.pkg"
        original = manifest.read_text()
        manifest.write_text(original + '\nimport { "Milky2018/selene/app" }\n')
        cases = {
            "raw_schedule": "try! @ecs.run_schedule(world, _ => ())",
            "world_param": "ignore(@app.App().add_system(Update, fn(_ : @ecs.World) {}))",
            "unsupported_param": "ignore(@app.App().add_system(Update, fn(_ : Int) {}))",
            "old_query_adapter": "ignore(@ecs.query_system(fn(_ : @ecs.Query[@ecs.Single[Position]]) {}))",
            "old_query_registration": "ignore(@app.App().add_query_system(Update, fn(_ : @ecs.Query[@ecs.Single[Position]]) {}))",
            "app_systems": "ignore(@app.App().systems)",
            "runtime_plan": "let plan : @app.RuntimePlan = abort(\"unreachable\"); ignore(plan)",
            "registered_system": "let entry : @app.RegisteredSystem = abort(\"unreachable\"); ignore(entry)",
            "system_bind": "ignore(@ecs.System(@ecs.args0(() => ())).bind)",
            "condition_bind": "ignore(@ecs.Condition(@ecs.args0(() => true)).bind)",
            "schedule_groups": "ignore(@ecs.Schedule().groups)",
        }
        try:
            for name, source in cases.items():
                with self.subTest(name=name):
                    result = self.compile(source, strict=False)
                    self.assertNotEqual(result.returncode, 0, result.stdout + result.stderr)
        finally:
            manifest.write_text(original)

    def test_required_resource_failure_is_isolated(self):
        result = self.run_program("""
struct Settings(Int)
let settings_key : @ecs.ResourceKey[Settings] = ResourceKey()
impl @ecs.Resource for Settings with resource_key() { settings_key }
fn main {
  let schedule = @ecs.Schedule().add_system(fn(settings : @ecs.Res[Settings]) {
    println(settings.get().0)
  })
  println("running uninitialized resource")
  try! schedule.run(@ecs.World())
}
""")
        output = result.stdout + result.stderr
        self.assertNotEqual(result.returncode, 0, output)
        self.assertIn("running uninitialized resource", output)
        self.assertIn("Resource is not initialized", output)

    def test_uninitialized_state_condition_failure_is_isolated(self):
        result = self.run_program("""
#derive(Eq)
enum Phase { Playing }
let phase_key : @state.StateKey[Phase] = StateKey()
impl @state.StateType for Phase with state_key() { phase_key }
fn main {
  let schedule = @ecs.Schedule().add_system(@ecs.args0(() => ()),
    run_if=@state.in_state(Phase::Playing))
  println("running uninitialized condition")
  try! schedule.run(@ecs.World())
}
""", state=True)
        output = result.stdout + result.stderr
        self.assertNotEqual(result.returncode, 0, output)
        self.assertIn("running uninitialized condition", output)
        self.assertIn("State is not initialized", output)

    def test_storage_access_is_rejected_outside_ecs(self):
        cases = {
            "component_store": ('let store : @ecs.ComponentStore[Position] = @ecs.components()\n  ignore(store)', "ComponentStore"),
            "global_components": ("ignore(@ecs.components())", "components"),
            "world_components": ("ignore(@ecs.components_in(world))", "components_in"),
            "key_store": ("ignore(position_key.store_in(world))", "store_in"),
            "key_current_store": ("ignore(position_key.store())", "store"),
            "key_get": ("ignore(position_key.get(@ecs.commands(world).spawn(())))", "get"),
            "key_set": ("position_key.set(@ecs.commands(world).spawn(()), Position(1))", "set"),
            "entity_metadata_storage": ("ignore(@ecs.Entities(world).store)", "abstract type"),
            "hierarchy_storage": ("ignore(@ecs.Hierarchy(world).store)", "abstract type"),
            "query_storage": ("let query : @ecs.Query[@ecs.Single[Position]] = world.query()\n  ignore(query.storage)", "abstract type"),
            "joined_constructor": ("ignore(@ecs.Query2(world.query(), world.query()))", "Query2"),
            "draft_store": ("@ecs.commands(world).draft().add_to(world.query(), Position(1))", "add_to"),
            "old_query_factory": ("ignore(world.query2())", "query2"),
            "immediate_spawn": ("ignore(world.spawn(()))", "spawn"),
            "immediate_spawn1": ("ignore(world.spawn1(Position(1)))", "spawn1"),
            "prepared_spawn": ("let plan : @ecs.SpawnPlan[@ecs.Single[Position]] = @ecs.commands(world).prepare_spawn()\n  ignore(plan.spawn(Single(Position(1))))", "spawn"),
            "draft_spawn": ("ignore(@ecs.commands(world).draft().spawn())", "spawn"),
            "immediate_delete": ("ignore(@ecs.commands(world).spawn(()).delete())", "delete"),
            "immediate_destroy": ("@ecs.commands(world).spawn(()).destroy()", "destroy"),
            "immediate_respawn": ("@ecs.commands(world).spawn(()).respawn()", "respawn"),
            "raw_flush": ("@ecs.flush_commands(world)", "flush_commands"),
            "lifecycle_flush": ("@ecs.flush_entity_lifecycle(world)", "flush_entity_lifecycle"),
            "world_storage": ("ignore(world.storage)", "storage"),
            "runtime_flush": ("@ecs.runtime_flush({}, world)", "runtime_flush"),
            "runtime_spawn": ("ignore(world.runtime_spawn({}, ()))", "runtime_spawn"),
            "runtime_spawn1": ("ignore(world.runtime_spawn1({}, Position(1)))", "runtime_spawn1"),
            "runtime_prepared_spawn": ("let plan : @ecs.SpawnPlan[@ecs.Single[Position]] = @ecs.commands(world).prepare_spawn()\n  ignore(plan.runtime_spawn({}, Single(Position(1))))", "runtime_spawn"),
            "runtime_draft_spawn": ("ignore(@ecs.commands(world).draft().runtime_spawn({}))", "runtime_spawn"),
            "runtime_delete": ("ignore(@ecs.commands(world).spawn(()).runtime_delete({}))", "runtime_delete"),
            "runtime_destroy": ("@ecs.commands(world).spawn(()).runtime_destroy({})", "runtime_destroy"),
            "runtime_respawn": ("@ecs.commands(world).spawn(()).runtime_respawn({})", "runtime_respawn"),
            "old_row_callback": ("let query : @ecs.Query[@ecs.Single[Position]] = world.query1()\n  query.for_each((_, _) => ())", "for_each"),
            "old_batch_traversal": ("let query : @ecs.Query[@ecs.Single[Position]] = world.query1()\n  query.for_each_batch(_ => ())", "for_each_batch"),
            "old_first_column_write": ("let query : @ecs.Query[(Position, Position)] = world.query()\n  query.for_each_batch_mut_a(_ => ())", "for_each_batch_mut_a"),
            "read_column_write": ("let query : @ecs.Query[@ecs.Single[Position]] = world.query1()\n  query.batches(batch => { let column : @ecs.ReadColumn[Position] = batch.read_column(); column.set(0, Position(1)) })", "set"),
            "column_storage": ("let query : @ecs.Query[@ecs.Single[Position]] = world.query1()\n  query.batches(batch => { let column : @ecs.ReadColumn[Position] = batch.read_column(); ignore(column.values) })", "abstract type"),
            "store_spawn": ("let query : @ecs.Query[@ecs.Single[Position]] = world.query()\n  ignore(query.spawn_plan(world))", "spawn_plan"),
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

    def run_program(self, source, *, state=False):
        # Fatal aborts do not unwind MoonBit defers. Isolate contracts that abort
        # inside an active query rather than poisoning the shared test process.
        manifest = self.consumer / "moon.pkg"
        original = manifest.read_text()
        manifest.write_text(original + '\nimport { "Milky2018/selene/app" }\npkgtype(kind: "executable")\n' + ('\nimport { "Milky2018/selene/state" }\n' if state else ""))
        (self.consumer / "access.mbt").write_text(COMPONENT + source)
        try:
            return subprocess.run(
                ["moon", "run", "--target", "wasm", "."], cwd=self.consumer,
                capture_output=True, text=True, timeout=120,
            )
        finally:
            manifest.write_text(original)

    def test_app_driver_cannot_flush_during_batch_callbacks(self):
        result = self.run_program("""
fn main {
  let world = @ecs.World()
  ignore(@ecs.commands(world).spawn1(Position(1)))
  let app = @app.App().with_world(world)
  app.run_frames(1)
  let query : @ecs.Query[@ecs.Single[Position]] = world.query1()
  query.batches(_ => {
    println("entered batch callback")
    app.run_frames(1)
  })
}
""")
        output = result.stdout + result.stderr
        self.assertNotEqual(result.returncode, 0, output)
        self.assertIn("entered batch callback", output)
        self.assertIn("App execution is forbidden inside a query batch", output)

    def test_internal_execution_packages_cannot_be_imported(self):
        manifest = self.consumer / "moon.pkg"
        original = manifest.read_text()
        for package in ("ecs_test", "state_runtime"):
            with self.subTest(package=package):
                manifest.write_text(original + f'\nimport {{ "Milky2018/selene/internal/{package}" }}\n')
                try:
                    result = self.compile("ignore(world.id())", strict=False)
                finally:
                    manifest.write_text(original)
                output = result.stdout + result.stderr
                self.assertNotEqual(result.returncode, 0, output)
                self.assertIn("internal", output)

    def test_manual_state_execution_is_not_public(self):
        manifest = self.consumer / "moon.pkg"
        original = manifest.read_text()
        manifest.write_text(original + '\nimport { "Milky2018/selene/state" }\n')
        try:
            for source, symbol in (
                ("try! @state.advance(world, on_exit=_ => (), on_enter=_ => ())", "advance"),
                ("try! @state.runtime_advance({}, world, on_exit=_ => (), on_enter=_ => ())", "runtime_advance"),
            ):
                with self.subTest(symbol=symbol):
                    result = self.compile(source, strict=False)
                    output = result.stdout + result.stderr
                    self.assertNotEqual(result.returncode, 0, output)
                    self.assertIn(symbol + " not found", output)
        finally:
            manifest.write_text(original)

    def test_deferred_commands_do_not_invalidate_ordinary_or_batch_iteration(self):
        result = self.run_program("""
fn main {
  let world = @ecs.World()
  let commands = @ecs.commands(world)
  ignore(commands.spawn1(Position(1)))
  ignore(commands.spawn1(Position(2)))
  let query : @ecs.Query[@ecs.Single[Position]] = world.query1()
  guard query.is_empty() else { abort("spawn was immediate") }
  let app = @app.App().with_world(world)
  app.run_frames(1)
  let mut visited = 0
  for entity, Single(position) in query {
    visited += 1
    commands.delete(entity)
    ignore(commands.spawn1(Position(position.0 + 10)))
  }
  guard visited == 2 && query.length() == 2 else { abort("commands changed rows") }
  app.run_frames(1)
  let mut sum = 0
  query.batches(batch => {
    let values : @ecs.ReadColumn[Position] = batch.read_column()
    for row in 0..<batch.length() {
      sum += values[row].0
      commands.delete(batch.entity(row))
    }
  })
  guard sum == 23 && query.length() == 2 else { abort("batch changed rows") }
  app.run_frames(1)
  guard query.is_empty() else { abort("delete did not flush") }
  println("deferred traversal passed")
}
""")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("deferred traversal passed", result.stdout)

    def test_query_for_loops_compile(self):
        result = self.compile("""
  ignore(@ecs.commands(world).spawn1(Position(1)))
  let query : @ecs.Query[@ecs.Single[Position]] = world.query1()
  for (entity, Single(position)) in query {
    world.set_component(entity, Position(position.0 + 1))
  }
  for entity, Single(position) in query {
    world.set_component(entity, Position(position.0 + 1))
  }
  let entries : Iter[(@ecs.Entity, @ecs.Single[Position])] = query.iter()
  ignore(entries.take(1).collect())
""")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_query_iterators_reject_structural_invalidation(self):
        for iterator in ("iter", "iter2"):
            for operation in (
                "ignore(commands.spawn1(Position(3)))",
                "ignore(commands.spawn((Position(3), Speed(4))))",
                "commands.delete(first); app.run_frames(1); ignore(commands.spawn1(Position(3)))",
            ):
                with self.subTest(iterator=iterator, operation=operation):
                    result = self.run_program("""
pub(all) struct Speed(Int)
let speed_key : @ecs.ComponentKey[Speed] = ComponentKey()
impl @ecs.Component for Speed with fn component_key() { speed_key }
fn main {
  let world = @ecs.World()
  let commands = @ecs.commands(world)
  let first = commands.spawn1(Position(1))
  ignore(first)
  let speeds : @ecs.Query[@ecs.Single[Speed]] = world.query1()
  ignore(speeds)
  ignore(commands.spawn1(Position(2)))
  let app = @app.App().with_world(world)
  app.run_frames(1)
  let query : @ecs.Query[@ecs.Single[Position]] = world.query1()
  let entries = query.""" + iterator + """()
  ignore(entries.next())
  """ + operation + """
  app.run_frames(1)
  println("advancing invalidated iterator")
  ignore(entries.next())
}
""")
                    output = result.stdout + result.stderr
                    self.assertNotEqual(result.returncode, 0, output)
                    self.assertIn("advancing invalidated iterator", output)
                    self.assertIn("query iterator invalidated by structural changes in its World", output)

    def test_batch_cannot_access_an_undeclared_component(self):
        result = self.run_program("""
pub(all) struct Speed(Int)
let speed_key : @ecs.ComponentKey[Speed] = ComponentKey()
impl @ecs.Component for Speed with fn component_key() { speed_key }
fn main {
  let world = @ecs.World()
  ignore(@ecs.commands(world).spawn((Position(1), Speed(2))))
  @app.App().with_world(world).run_frames(1)
  let query : @ecs.Query[@ecs.Single[Position]] = world.query1()
  query.batches(batch => {
    println("entered query callback")
    let speed : @ecs.WriteColumn[Speed] = batch.write_column()
    ignore(speed.length())
  })
}
""")
        output = result.stdout + result.stderr
        self.assertNotEqual(result.returncode, 0, output)
        self.assertIn("entered query callback", output)
        self.assertIn("component is not declared in this query", output)


if __name__ == "__main__":
    unittest.main()
