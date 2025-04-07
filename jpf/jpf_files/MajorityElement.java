import probabilistic.UniformChoice;
/**
 * An implementation of a randomized algorithm to determine if an array of integers
 * has a majority element (number of occurrences is more than half of the array)
 * This is a Monte Carlo algorithm, with probability of error less than (1/2)^N where
 * N is the number of trials
 * @author maeve
 *
 */
public class MajorityElement {
	/**
	 * 
	 * @param a, an int array representing the collection to be searched for a majority element
	 * @param trials, number of repetitions of the algorithm
	 * @return boolean, whether or not there is a majority element
	 */
	
	public static boolean majority (int [] a, int trials) {
		for (int j=0; j<trials; j++) {
			int index = UniformChoice.make(a.length);
			int element = a[index];
			int count = 0;
			for (int i=0; i<a.length; i++) {
				if (a[i]==element) {
					count++;
				}
			}
			if (count > (a.length)/2) {
				return true;
			}
		}
		return false;
	}
}

