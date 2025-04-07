/*
 * This class calls the majority element class.
 * 
 * @author Yash Dhamija
 */
public class MajorityElementTest {

	/*
	 * This methods takes in command line argument and processes it for MajorityElement's majority method.
	 * @param and array, of string whose first element shows the number of trials, and the rest
	 * makes an int[] array
	 */
	
	// normal version of finding the majority element
	public static boolean findMajority (int[] a) {
		for (int i = 0; i < a.length; i++) {
			int element = a[i];
			
			int count = 0;
			
			for (int j = 0; j < a.length; j++) {
				if (a[j]== element) {
					count++;
				}
			}
			if (count > (a.length)/2) {
				return true;
			}
		}
		return false;
	}
	
	
	
	public static void main(String[] args) {
		if (args.length < 2) {
			System.out.println("Usage: [0-9], int*");
			System.exit(0);
		}
		
		int[] arr = new int[args.length-1];
		
		for (int i = 1; i < args.length; i++) {
			arr[i-1] = Integer.parseInt(args[i]);
		}
		
		boolean falsePositive = false;
		
		boolean result = findMajority(arr);
		
		falsePositive = !(MajorityElement.majority(arr, Integer.parseInt(args[0])) == result);
	}
}

