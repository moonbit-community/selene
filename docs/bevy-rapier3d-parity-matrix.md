# Selene Physics3D vs Bevy Rapier3D Parity Matrix

Last updated: 2026-04-01

## Status Legend

- `DONE`: implemented and covered by local tests
- `IN_PROGRESS`: implemented but test coverage or behavior depth is incomplete
- `TODO`: not aligned yet

## Matrix

| Area | Bevy / bevy_rapier3d Surface | Selene Surface | Status | Evidence | Next |
| --- | --- | --- | --- | --- | --- |
| Rigid body core components | `RigidBody`, `Velocity`, `Damping`, `GravityScale`, `LockedAxes`, `Ccd`, `Dominance`, `AdditionalMassProperties` | `selene/physics3d` same-named components | `DONE` | API exists in [`selene-core/src/physics3d/top.mbt`](/Users/zhengyu/Documents/projects/selene/selene-core/src/physics3d/top.mbt), forwarding tested in wbtests (`dominance`). | Keep regression coverage when moon_rapier updates. |
| Collider and collision configuration | `Collider`, `Sensor`, `Friction`, `Restitution`, `CollisionGroups`, `SolverGroups`, `ActiveCollisionTypes`, `ActiveEvents`, `ActiveHooks`, `ContactForceEventThreshold`, `ColliderMassProperties` | `selene/physics3d` same-named components (active* via rapier collision types) | `DONE` | API and sync paths in [`top.mbt`](/Users/zhengyu/Documents/projects/selene/selene-core/src/physics3d/top.mbt); solver groups tested. | Add explicit wbtests for all active-event/hook combinations. |
| Query context operations | `RapierContext` ray/shape/point/project queries + `QueryFilter` | `RapierContext.cast_ray/cast_shape/intersections_with_point/intersections_with_shape/project_point` + `QueryFilter` | `IN_PROGRESS` | Query APIs and filter conversion implemented in [`top.mbt`](/Users/zhengyu/Documents/projects/selene/selene-core/src/physics3d/top.mbt); wbtests now cover groups, body-filter, exclude-entity, exclude-sensors, exclude-solids, and project/intersections. | Add wbtests for `cast_shape` filter matrix and kinematic-only query scenarios. |
| Collision/Sensor/Force events | `CollisionEvent`, `IntersectionEvent`, `ContactForceEvent` | `collision_event_bus`, `sensor_event_bus`, `contact_force_event_bus` | `IN_PROGRESS` | Event collection in [`top.mbt`](/Users/zhengyu/Documents/projects/selene/selene-core/src/physics3d/top.mbt); wbtests cover collision+intersection mapping and contact force forwarding. | Add threshold behavior test around default vs low `ContactForceEventThreshold`. |
| Impulse and multibody joints | fixed/revolute/prismatic/rope/spring/spherical, motor/limits/softness/contacts | `ImpulseJoint`, `MultibodyJoint`, `Joint` enum with all six types | `IN_PROGRESS` | Joint conversion paths exist in [`top.mbt`](/Users/zhengyu/Documents/projects/selene/selene-core/src/physics3d/top.mbt); wbtests currently cover handle creation and `contacts_enabled` for fixed/revolute. | Add whitebox behavior tests for prismatic/rope/spring/spherical and motor/limits/softness paths. |
| Character controller | slide, snap, autostep, slope options, output collisions | `KinematicCharacterController` + output/collision components | `IN_PROGRESS` | Controller component + runtime update exists in [`top.mbt`](/Users/zhengyu/Documents/projects/selene/selene-core/src/physics3d/top.mbt); wbtest covers output writeback and translation consume. | Add scenario tests for slope climb/slide, autostep, and snap-to-ground. |
| Transform hierarchy integration | collider relative to rigid-body ancestor, same-entity transform, writeback | hierarchy sync and transform writeback logic | `DONE` | wbtests cover same-entity and child-collider-relative behavior in [`top_wbtest.mbt`](/Users/zhengyu/Documents/projects/selene/selene-core/src/physics3d/top_wbtest.mbt). | Keep as regression suite baseline. |

## Current Priority

1. Complete joint behavior coverage (limits/motor/softness/contact toggles for all joint kinds).
2. Complete query filter matrix (`exclude_sensors` / `exclude_solids` / shape cast).
3. Complete character controller scenario coverage (autostep/snap/slope).
