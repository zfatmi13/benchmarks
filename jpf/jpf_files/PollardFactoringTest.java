/*
 * A simple class to obtain a factor of N.
 * used for jpf.
 * 
 * @author Yash
 */
public class PollardFactoringTest {

	public static void main(String[] args) {
		if (args.length != 1) {
			System.out.println("Usage: <int N that is not a prime>");
			System.exit(0);
		}

		boolean sameAsInput = false;
		
		int input = Integer.parseInt(args[0]);
		
		sameAsInput = PollardFactoring.factor(input) == input;
	}
}
