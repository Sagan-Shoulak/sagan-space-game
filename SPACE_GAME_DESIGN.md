# Space Game Design Document

## Concept

Space Game is a space-based resource-management and exploration game. It begins
with a doomed Earth and a sizable human presence in space sometime in the near
future. Humanity must move its production capabilities off-planet and prepare
to live away from Earth until a new home can be found.

The player will create outposts, extract and refine resources, establish
additional outposts, and build a fleet capable of temporarily housing humanity
while searching for a new home among the stars.

All gameplay choices and implementations should be backed with hard science/data (preferable) or a reasonable sci-fi reference.

## Entities

### Natural Bodies

Natural bodies include Sol, the planets, their major moons, the dwarf planets,
some comets, and many asteroids. An outpost built on a natural body is called a
**base**. Natural bodies will have realistic resource distributions so that
building multiple bases on the same planet can serve a purpose.

### Vehicles

Vehicles are central to the game and include several subtypes.

#### Ships

Ships may be manned or unmanned and have the following systems:

- Chassis
- Navigation
- Engines
- Life support, if manned
- Storage
  - Fuel
  - Life-support supplies, if manned

Communication should be abstracted, while sensors should maybe be abstracted.
Neither should necessarily be a separate system that the player has to install
and manage. Likewise, the Stability Augmentation System (SAS) and Reaction
Control System (RCS) should be abstracted as part of a ship's propulsion rather
than being separate systems.

I'm not sure if ships should be allowed to be autonomous. They should not
necessarily be able to operate independently without people just because
automated resource routes exist.

The chassis is the core of a ship and determines what the ship can become. It
has slots for required systems and may provide additional slots for
customization.

Non-mandatory chassis slots are called **machine slots** and hold machines.
Machines are the category for miscellaneous systems, including systems used
for research, resource extraction, and resource refinement.

### Outposts

Outposts are the counterpart to vehicles and have a major role in the game.
They may be built on a surface, where they are called **bases**, or freestanding
in space, where they are called **stations**. Like vehicles, outposts have
chassis composed of slots that allow a base or station to be customized.
Stations may only be placed at Lagrange points.

### Drones

Drones are the final type of entity and the only entity type that is not
first-class. Planetary bodies have no agent because their behavior is the result
of predetermined calculations. Unmanned vehicles may require simple agents.
Outposts do not themselves require agents, but drones support vehicles and
outposts by handling tasks that need the same level of agency as an unmanned
ship without being independent, self-existing entities.

For example, a station may have a machine that provides repair drones capable
of servicing visiting ships. These repair drones need some agency to perform
their tasks, but they are not considered ships because their activities are
closer to animations than independent actions.

Trucks should be treated the same way. Planetside trucking is impractical, so
surface transportation should be handled by drone-like machines rather than
trucks being first-class entities.

This distinction is clearer when compared with a ship running a resource route
and transporting materials between planets. That ship should not be assigned
the same level of complexity or implied identity as a repair drone, even though
the drone may share many systems with ships.

## Narrative

*To be defined.*

## Gameplay

### Overview

extract → refine → transport → build → maintain → expand → evacuate

### Mechanics

#### Resources

As much as possible, for every feature in the game that requires a consumable
resource, that resource will be present in the game and accurate to its
real-life counterpart. For example, if you want rocket fuel you better be
prepared to procure some methane or hydrogen and oxygen.

##### Extraction

Resources can be extracted from Natural Bodies by Bases, and some Vehicles, by
having the requisite machine installed (and storage available).

##### Refinement

Likewise, resources can be refined by having the corresponding machine
installed and the proper materials present (and storage for the inputs and
outputs, of course).

##### Transportation

Resources can be transported along automated routes by Vehicles. Automated
Routes are calculated and simulated, but things like the final rendezvous and
docking are "hand-waved" so that the math does not need to be perfect for a
planned mission to go as planned. NOTE: This has to be carefully guaranteed.

##### Consumption

Systems and Machines may consume Resources.

#### Power

Power will need to be generated and stored for many things to be able to run. Ships may need nuclear reactors. There may be things like giant space-based solar arrays and beamed-energy technology.

#### Heat

Heat will need to be managed. Some things (like people) need to be kept warm. Other things (like nuclear reactors) need to be kept cool.

#### Ships

*To be defined.*

##### Creation

Outposts will be able to create ships.

##### Customization

The core of each ship is its Chassis, which has Slots that allow you to install
systems and machines that determine the capabilities and other details of the
ship. Hopefully paint schemes can be a thing too.

#### Mechanical Systems

No system is perfect.

##### Degradation

Machines will degrade over time and need repair. Your machines will not last
forever.


##### Random Events

Sometimes, things can just suddenlyt degrade by a sizable amount due to random events, maybe sometimes involving crew members with low comfort.

##### Repair

Anything can be repaired. Unlike resources, this will not be as real-life
accurate; we'll do some major handwaving allowing things to be able to be fixed
with a limited list of "Parts" (advanced parts, electronic parts, chassis parts
grade 3, what have you) such that the ability to repair things is not the most
crunchy part of the game.

#### Life Support

Folks can die. Like the math and science in other parts of the game, this is
going to be accurate to the age and activity of the people in the game. Folks
will need to have the appropriate provided resources, with things like oxygen
consumption being directly calculated.

##### Food

Gotta feed them.

##### Water

*To be defined.*

##### Oxygen

*To be defined.*

##### Sleep

Not sure exactly how to tie this in, this may just fall under the heading of
comfort. If nothing else, it helps determine the available number of man-hours
you have per day. Some number of people have to be asleep at a certain time.

##### Comfort

I don't want to go tooooo crazy on this at the get-go, but I do want it to be a
bad thing if you cut the corners on absolutely everything for everyone. For
example, maybe providing more food and water than they need and enabling them to
eat more than the bare minimum provides a boost. Maybe having amenities raises
morale and gives people a temporary buff to their job performance.

#### Population

The civilian population is all the people not employed in the running of the
space program. It should be abstracted rather than simulated as individual
people. The goal of the game is to eventually get as many as you can to a new
home among the stars. At every step of the journey though, not all of the
population will be willing to make the move, nor may there be transportation
available for everyone. Tough choices will need to be made, and some will be
made as fait accompli. You can't save everyone, but you must save humanity.

##### Management

*To be defined.*

##### Housing

They need to have a safe place to live until we can find all of humanity a new
home among the stars.

##### Education

Some effort has to be put in by the player to guarantee that in further
generations, humanity is still able to train people to be able to perform the
tasks needed by the space program. In actuality, this may just be a way to
"promote" people from civilians into employees, but considering these pilots
can't live forever, there will need to be new humans taking over.

##### Life Support

Same as on a ship, the health of the population must be satisfied.

##### Transportation

Transport ships must be built to move them from the dying Earth to wherever
their new refuge will be.

#### Terraforming

Earth is doomed (why is TBD), but other planets may have things performed to
affect their environment to ease the pressure on needing to find their new home
quite as urgently. NOTE: We likely need to ensure that Earth can never be
restored to close to its previous status in order to ensure the terraforming of
next best options (like Mars), and likewise no body can ever be terraformed to
the point that it is perfectly habitable, otherwise

#### Exploration

The player will need to explore other bodies and star systems to be able to find
a new home among the stars.

#### Research

Science points must be able to be gathered to allow a tech tree and tech
progression needed for there to be such a capability disparity as being
basically not far from where we are right now in real life to eventually
becoming a truly space-faring civilization.

##### Technology Tree

There will be one.

#### Fleet Management

Vehicle and Outpost Management is the absolute core of the game and the vast
majority of the game loop.

### Endgame and New Game Plus

The game "ends" when you leave the current star system for the next one. In
each subsequent star system, the most habitable planet will be slightly more
habitable than the previous system's most habitable planet.

In the Solar System, Earth will start as the most habitable planet, but Mars
will take over as Earth deteriorates. The most habitable planet in the next
star system will therefore be somewhat more habitable than Mars. If you choose
to continue playing after settling on that planet, you will have begun a New
Game Plus in the new star system.

## Physics

The game aims for a high level of physical realism, including support for
Lagrange points. The exact simulation model remains to be defined.

One important facet is how we're going to simulate gravity. Certain things
should be true:

- Natural bodies should not be able to deviate from their true and defined
  orbits due to our bad math, while some should be able to be moved by the
  player. We have not yet ruled out the idea that the player may be able to
  meaningfully change the orbits of asteroids and other small natural bodies.
  However, things like moons should not be able to have their orbits
  non-deliberately noticeably deviate from their counterparts. For example,
  very small moons and moons of very large planets need to operate under sound
  enough orbital rules as to not be able to go rogue or anything like that.

Perhaps the solution is to have 3 categories of mass for entities:

- hypomassive (receives gravitational force from locally relevant bodies,
  doesn't exert it);
- massive (receives gravitational force from only its parent, and exerts it on
  other non-hypermassive bodies); and
- hypermassive (exerts gravitational force, but doesn't receive it, except from
  its parent).

This allows hypomassive entities to receive the most perturbed gravity, things
like asteroids and small moons to have fairly stable experiences, and things
that we want to behave very locked down experience the least gravitational
simulation at all. This also helps us reduce our calculations per second in the
most intensive part of the game.

## Roadmap

1. Get all the Natural Bodies simulated such that all the orbital functionality
   has been settled. The simulation of orbiting bodies is going to be one of the
   most taxing parts of the game, so this will help us define our bandwidth as
   well as the number of entities we can continue to work with. If we are not
   able to simulate the number of entities that we want to, we may need to do
   something clever.
2. Get outposts up and rocking, so we can begin the work on the resource
   management part, and when it's time to get to ships we can actually build
   them using the gameplay from this step.
3. Vehicles enter the picture. Once we have both outposts and vehicles
   supported, the vast majority of gameplay is ready to be developed.
4. Drones, a small milestone but needs to stand on its own.
5. UI polishing. We'll need to get this to actually look and feel like a game at this step, even if asset quality is terrible.

Steps 1-5 should begin as a vertical slice: Earth and Moon, a few bases, a few
stations, a few ships, and a few different kinds of drones.

6. Mechanical refinement. Make sure that we have a strong understanding of what
   game balance looks like, and what levers we have to pull. We should be able
   to get a fully self-sustaining setup in our game such that we are able to
   harvest enough resources to maintain our fleet which is sizable enough to do
   more than maintain the status quo: a true surplus of all managed resources.
7. Asset refinement. Now that we have the first chapter of the game unlocked
   and refined, we should have enough of a proof of concept to be able to
   actually devote time and money to quality assets.
8. Narrative and Expansion Development. At this point we should know enough
   about how the game plays to write a story around it and have a strong idea of
   what the gameplay looks like from beginning to end, including any features
   that may only be found outside of the Solar System.
9. Expansion. This is the point when we should feel comfortable going into
   Early Access. We have a playable demo, and a strong idea of how we're going
   to expand it into the final product. At this point, there would be nothing
   much left to do except finish the game. This would of course include more
   asset, mechanic, narrative, and balance development.
10. Test and Publish 1.0. At this point we should be comfortable charging the
    price we are for our completed product.
11. Then, because of course we will, we can continue to support and expand the
    game with updates. If nothing else we should support it long enough to find
    and fix any bugs or issues from the players, and if we're enjoying it still
    we should continue to release content (so long as we fix more bugs than we
    release, lowering our tech debt over time).

## Known Questions

- What exists in each subsequent star system besides an increasingly habitable
  planet?
- Should ships be allowed to be autonomous?
- Which systems for a ship provide real and interesting gameplay changes? For
  example, what does better navigation actually do? For some of the more subtle
  systems, we need to decide if they're better in your face and customizable,
  or behind the scenes and abstracted.
