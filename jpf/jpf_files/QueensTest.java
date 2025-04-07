public class QueensTest {

	public static void main (String [] args) {
		final int ARGS = 2;
		if (args.length != ARGS) {
			System.out.println("Usage: Queens <number of repititions> <size of the board>");
			System.exit(0);
		}

		int n = Integer.parseInt(args[1]);

		boolean success = false;
		
		for (int trials =0; trials<Integer.parseInt(args[0]); trials++) {
			int [][] board = new int [n][n];

			success = Queens.Queens(0, board, n) == true;			
		}	
	}
}
