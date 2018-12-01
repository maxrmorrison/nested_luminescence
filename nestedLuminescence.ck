/* Utility classes for statistic analysis and
   cartesian and polar coordinate operations */
Machine.add(me.dir() + "include/Stat.ck");
Machine.add(me.dir() + "include/Position.ck");
/* Basic Ambisonics encoder/decoder Chubgraph for planar
   Ambionic spatialization */
Machine.add(me.dir() + "include/Ambisonics.ck");
/* Add abstract Firefly base class and inherited classes
   containing gender-specific behaviors */
Machine.add(me.dir() + "include/Firefly.ck");
Machine.add(me.dir() + "include/MaleFirefly.ck");
Machine.add(me.dir() + "include/FemaleFirefly.ck");
/* Add the nest, which oversees the simulation */
Machine.add(me.dir() + "include/Nest.ck");
/* Create a nest object to carry out simulation */
Machine.add(me.dir() + "buildNest.ck");
