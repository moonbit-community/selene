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
| Query context operations | `RapierContext` ray/shape/point/project queries + `QueryFilter` | `RapierContext.cast_ray/cast_shape/intersections_with_point/intersections_with_shape/project_point` + `QueryFilter` | `DONE` | Query APIs and filter conversion implemented in [`top.mbt`](/Users/zhengyu/Documents/projects/selene/selene-core/src/physics3d/top.mbt); wbtests cover groups, body-filter (`dynamic/fixed/kinematic`), exclude-entity, exclude-sensors, exclude-solids, `cast_shape` filtering, and project/intersections. | Keep parity regression suite green as moon_rapier evolves. |
| Collision/Sensor/Force events | `CollisionEvent`, `IntersectionEvent`, `ContactForceEvent` | `collision_event_bus`, `sensor_event_bus`, `contact_force_event_bus` | `DONE` | Event collection in [`top.mbt`](/Users/zhengyu/Documents/projects/selene/selene-core/src/physics3d/top.mbt); wbtests cover collision+intersection mapping, contact force forwarding, and threshold-driven contact-force event activation (default vs low threshold). | Keep event regression coverage green as moon_rapier evolves. |
| Impulse and multibody joints | fixed/revolute/prismatic/rope/spring/spherical, motor/limits/softness/contacts | `ImpulseJoint`, `MultibodyJoint`, `Joint` enum with all six types | `IN_PROGRESS` | Joint conversion paths exist in [`top.mbt`](/Users/zhengyu/Documents/projects/selene/selene-core/src/physics3d/top.mbt); wbtests cover variant routing for all six joint kinds on both impulse/multibody paths, and `contacts_enabled` for fixed/revolute/rope/spring impulse cases. Impulse rope/spring now route through generic joints and expose stable handles. | Add behavior-level tests for limits/motor/softness coverage. |
| Character controller | slide, snap, autostep, slope options, output collisions | `KinematicCharacterController` + output/collision components | `IN_PROGRESS` | Controller component + runtime update exists in [`top.mbt`](/Users/zhengyu/Documents/projects/selene/selene-core/src/physics3d/top.mbt); wbtest covers output writeback and translation consume. | Add scenario tests for slope climb/slide, autostep, and snap-to-ground. |
| Transform hierarchy integration | collider relative to rigid-body ancestor, same-entity transform, writeback | hierarchy sync and transform writeback logic | `DONE` | wbtests cover same-entity and child-collider-relative behavior in [`top_wbtest.mbt`](/Users/zhengyu/Documents/projects/selene/selene-core/src/physics3d/top_wbtest.mbt). | Keep as regression suite baseline. |

## Current Priority

1. Complete joint behavior coverage (limits/motor/softness assertions).
2. Complete character controller scenario coverage (autostep/snap/slope).
