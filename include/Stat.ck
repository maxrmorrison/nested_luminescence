/*
Utility class for managing basic statistics operations related to 
normal distributions. Pre-computed table values are used when needed
for efficiency
*/
public class Stat {
	/* Pre-calculated values for normal distribution percentiles */
	-1.28 => static float TENTH_PERCENTILE;
	-0.84 => static float TWENTIETH_PERCENTILE;
	-0.52 => static float THIRTIETH_PERCENTILE;
	-0.25 => static float FOURTIETH_PERCENTILE;
	 0.00 => static float FIFTIETH_PERCENTILE;
	 0.26 => static float SIXTIETH_PERCENTILE;
	 0.53 => static float SEVENTIETH_PERCENTILE;
	 0.85 => static float EIGHTIETH_PERCENTILE;
	 1.29 => static float NINETIETH_PERCENTILE;
	/* Returns an approximately normally distributed value from a distribution
	   with provided mean, standard deviation, and number of trials */
	fun static float randn(float mean, float sd, int n) {
		float result;
		repeat (12) Math.random2f(0.0, 1.0) +=> result;
		6.0 -=> result;
		return result * sd / Math.sqrt(n) + mean;
	}
	/* Takes as input a value within a normal distribution and the parameters
	   of that normal distribution. Converts value to standard distibution
	   and outputs an index corresponding to the percentile range. */
	fun static int normalValueToPercentileIndex(float normalValue, float mean,
												float sd, int n) {
		(normalValue - mean) / (sd / Math.sqrt(n)) => float standardizedValue;
		/* Index the partial normal area table found in the static variables above */
		if      (standardizedValue < TENTH_PERCENTILE)      { return 9; }
		else if (standardizedValue < TWENTIETH_PERCENTILE)  { return 8; }
		else if (standardizedValue < THIRTIETH_PERCENTILE)  { return 7; }
		else if (standardizedValue < FOURTIETH_PERCENTILE)  { return 6; }
		else if (standardizedValue < FIFTIETH_PERCENTILE)   { return 5; }
		else if (standardizedValue < SIXTIETH_PERCENTILE)   { return 4; }
		else if (standardizedValue < SEVENTIETH_PERCENTILE) { return 3; }
		else if (standardizedValue < EIGHTIETH_PERCENTILE)  { return 2; }
		else if (standardizedValue < NINETIETH_PERCENTILE)  { return 1; }
		else 												{ return 0; }
	}
}
