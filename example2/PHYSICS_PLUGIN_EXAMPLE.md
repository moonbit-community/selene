# Physics Plugin Example

This example demonstrates how to use the Selene physics plugin with minimal setup.

## Setup

```moonbit
// Add physics plugin to your app
@system.App::new(backend)
  .add_plugin(@plugins.default_plugin)  // Basic Selene systems
  .add_plugin(@plugins.physics_plugin)  // Physics system
  .run()
```

## Creating Physics Entities

```moonbit
// Create a dynamic physics entity (affected by gravity and forces)
let ball = @system.Entity::new()
@physics.create_physics_entity(ball, @math.Vec2D(100.0, 50.0), @physics.Dynamic, 1.0)

// Create a static physics entity (immovable)
let ground = @system.Entity::new()
@physics.create_physics_entity(ground, @math.Vec2D(200.0, 300.0), @physics.Static, 0.0)

// Create a kinematic entity (user-controlled)
let platform = @system.Entity::new()
@physics.create_physics_entity(platform, @math.Vec2D(150.0, 200.0), @physics.Kinematic, 0.0)
```

## Applying Forces and Impulses

```moonbit
// Apply continuous force (like wind)
@physics.apply_force_to_entity(ball, @math.Vec2D(10.0, 0.0))

// Apply instant impulse (like jumping or explosion)
@physics.apply_impulse_to_entity(ball, @math.Vec2D(0.0, -50.0))

// Set velocity directly (for kinematic objects)
@physics.set_physics_velocity(platform, @math.Vec2D(20.0, 0.0))
```

## Getting Physics Data

```moonbit
// Get current velocity
match @physics.get_physics_velocity(ball) {
  Some(velocity) => println("Ball velocity: \{velocity[X]}, \{velocity[Y]}")
  None => println("No physics velocity component")
}
```

## What the Physics Plugin Provides

1. **Gravity simulation** - Objects fall down automatically
2. **Force integration** - Apply forces that affect velocity over time  
3. **Impulse application** - Instant velocity changes
4. **Velocity damping** - Objects slow down naturally
5. **Multiple body types** - Static, Kinematic, Dynamic
6. **ECS integration** - Works with Selene's position system

## What's NOT Included

- **Collision detection** between objects
- **Shape-based physics** (all objects are points)
- **Constraints and joints**
- **Advanced physics features**

This is a basic physics system suitable for simple games with gravity, forces, and movement.

## Complete Example

See `src/main.mbt` for a complete working example with:
- Multiple physics objects
- Boundary collision (custom system)
- UI with sprites  
- Interactive object creation