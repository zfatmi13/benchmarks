
public class SetIsolationTest {

	/*
	 * Parses input as arguments for SetIsolation
	 * @param array of string, where first element is number of trials , 
	 * second is the size of universe, third is size of Set S and fourth is size of set T, 
	 * and the rest are elements of set S and T respectively.
	 * For e.g, 5, 21, 4, 4, 5, 10, 15, 20, 4, 11, 17, 19 means
	 * 5 trials, size of universe is 21, 4 elements of S={5, 10, 15, 20} and T={4, 11, 17, 19} 
	 */
	public static void main(String[] args) {
		if (args.length < 4) {
			System.out.println("Usage: [0-9]{4},[0-9]{2+}");
			System.exit(0);
		}

		boolean isGoodSample = false;
		boolean test = true;

		int sl = Integer.parseInt(args[2]);
		int tl = Integer.parseInt(args[3]);
		if (args.length-4 != sl+tl) {
			System.out.println("Invalid input: Wrong number of edges provided");
			System.exit(0);
		}
		int[] s = new int[sl];
		int[] t = new int[tl];
		int i = 4;
		for (; i < sl+4; i++)
			s[i-4] = Integer.parseInt(args[i]);
		for (; i < args.length; i++)
			t[i-4-sl] = Integer.parseInt(args[i]);

		isGoodSample = SetIsolation.check(Integer.parseInt(args[0]), Integer.parseInt(args[1]), s, t);
	}
}
