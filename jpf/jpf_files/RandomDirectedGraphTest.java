/*
 * This class creates a random graph.
 * 
 * @author Yash Dhamija
 */
public class RandomDirectedGraphTest {

	/*
	 * creates a graph (n x n matrix).
	 * 
	 * @param args[0] the dimension of the graph matrix, 
	 * args[1] a real number in [0,1)that implies the probability of an edge between any two nodes .
	 */
	
	public static void main(String[] args) {
		if (args.length != 2) {
			System.out.println("Usage: <dimension of graph matrix> <Probability of an edge between any two nodes>");
			System.exit(0);
		}
		RandomGraph rg = new RandomGraph(Integer.parseInt(args[0]), Double.parseDouble(args[1]));
		rg.createDirectedGraph();
	}
}