/*
Simulates the mating patterns of a nest of male and female fireflies
Mating probabilities and factors are based on results presented in
	Cratsley, Christopher K., and Sara M. Lewis. "Female preference
	for male courtship flashes in Photinus ignitus fireflies."
	Behavioral Ecology 14.1 (2003): 135-140.
*/
public class Nest {
	/* May need to decrese number of fireflies for real-time
	   playback if artifacts occur */
	MaleFirefly males[12];
	FemaleFirefly females[8];
	/* Define a circle around the origin
	   Keep some space between closest fireflies and origin
	   to minimize effects of inverse square law
	   Distances assumed to be in meters for convenience */
	5.0 => float MAX_DISTANCE;
	1.0 => float MIN_DISTANCE;
	/* Run the entire nest simulation in an infinite loop */
	init();
	now + 2::minute => time stop;
	while (now < stop) {
		for (int i; i < males.size(); ++i)   updateMalePosition(males[i]);
		for (int i; i < females.size(); ++i) updateFemalePosition(females[i]);
		10::ms => now;
	}
	/* Initialize each firefly to a random point in the nest */
	fun void init() {
		for (int i; i < males.size(); ++i)   randomSpawnPoint(males[i]);
		for (int i; i < females.size(); ++i) randomSpawnPoint(females[i]);
	}
	/* Initialize a single firefly's position to a random point in the nest */
	fun void randomSpawnPoint(Firefly firefly) {
		Math.random2f(1.0, 5.0)       => float radius;
		Math.random2f(-Math.PI, Math.PI) => float theta;
		firefly.position.setPolar(radius, theta);
		firefly.effectsUpdate();
	}
	/* Male trajectory is pseudorandom and not influenced by female behaviors */
	fun void updateMalePosition(MaleFirefly male) {
		Math.random2f(0.004, 0.012) => float dist;
		Math.random2f(-Math.PI, Math.PI) => float theta;
		polarUpdate(male, dist, theta);
	}
	/* Female trajectory is based on the desirability of the males in the vicinity */
	fun void updateFemalePosition(FemaleFirefly female) {
		findMostDesirable(female) @=> MaleFirefly@ male;
		/* Do not move if no male is attractive enough */
		if (female.attraction < 0.01) return;
		/* Mating occurs if and only if male and female within 4 cm
		   This also causes both male and female to be reset */
		distanceBetween(male.position, female.position) => float dist;
		if (dist < 0.04) {
			connect(male, female);
			return;
		}
		/* Move in the direction of the most desirable male */
		Math.atan2(male.position.y - female.position.y,
				   male.position.x - female.position.x) => float theta;
		0.02 * female.attraction => float moveDist;
		polarUpdate(female, moveDist, theta);
	}
	/* Given a distance to move and direction, convert this to an update
	   in cartesian coordinates and apply the update
	   All fireflies create a sound with their wings when moving */
	fun void polarUpdate(Firefly firefly, float dist, float theta) {
		dist * Math.cos(theta) => float x_inc;
		dist * Math.sin(theta) => float y_inc;
		firefly.position.update(x_inc, y_inc);
		checkBoundaries(firefly);
		firefly.effectsUpdate();
	}
	/* Returns a reference to the male considered the most desirable
	   by the female passed in as an argument
	   Desirability is based on flash duration, lantern area, and distance */
	fun MaleFirefly@ findMostDesirable(FemaleFirefly female) {
		float maxDesirability;
		males[0] @=> MaleFirefly@ mostDesirable;
		for (int i; i < males.size(); ++i) {
			distanceBetween(female.position, males[i].position) => float distance;
			/* Male firefly is too far away */
			if (distance > 2.0) continue;
			/* Desirability scales with distance */
			males[i].desirability * ((2.0 - distance) / 2.0) => float desirability;
			/* New candidate found with superior desirability */
			if (desirability > maxDesirability) {
				desirability => maxDesirability;
				males[i] @=> mostDesirable;
			}
		}
		maxDesirability => female.attraction;
		return mostDesirable;
	}
	/* Return distance between two positions */
	fun float distanceBetween(Position pos1, Position pos2) {
		return Math.hypot(pos2.x - pos1.x, pos2.y - pos1.y);
	}
	/* If the firefly wanders out of the nest, move it back within bounds */
	fun void checkBoundaries(Firefly firefly) {
		if (firefly.position.distance < 1.0) {
			firefly.position.setPolar(1.01, firefly.position.theta);
		}
		else if (firefly.position.distance > 5.0) {
			firefly.position.setPolar(4.98, firefly.position.theta);
		}
	}
	/* Triggers a sound to signify the mating of the fireflies
	and resets their positions to random values */
	fun void connect(MaleFirefly male, FemaleFirefly female) {
		spork ~ male.playConnectSound();
		male.reset();
		female.reset();
		randomSpawnPoint(male);
		randomSpawnPoint(female);
	}
}
