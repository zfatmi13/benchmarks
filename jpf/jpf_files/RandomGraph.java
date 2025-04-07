import java.util.*;
import probabilistic.Choice;

public class RandomGraph {
	private int n;
	private double p;
	private int [][] graphMatrix;
	
	
	public RandomGraph(int n, double p) {
		this.graphMatrix  = new int [n][n];
		this.n = n;
		this.p = p;
	}
	
	public void DFS (int start, int[][] matrix, boolean [] visited) {
		
		// set the start node as "visited"
		visited[start] = true;
		
		// loop through each node
		for (int i = 0; i < matrix.length; i++) {
			// If some node is adjacent to the current node 
	        // and it has not already been visited 
	        if (matrix[start][i] == 1 && (!visited[i])) { 
	            DFS(i, matrix, visited); 
	        } 
		}
	}
	
	public boolean isConnectedDirectedVer (int[][] matrix) {
		
		int size = matrix.length;
		
		// define visited array
		boolean[] visited = new boolean[size];
		
		for (int i = 0; i < size; i++) {
			// set all elements to false, means no node has been visited
			for (int j = 0; j < visited.length ; j++) {
				visited[j] = false;
			}
			
			DFS(i, matrix, visited);
			
			// check if there is any node not visited by DFS
			for (int j = 0; j < visited.length; j++) {
				if (!visited[j]) {
					return false;
				}
			}
		}
		return true;
	}
	
	public boolean isConnectedUndirectedVer (int[][] matrix) {
		int size = matrix.length;
		
		// define visited array
		boolean[] visited = new boolean[size];
		
		// set all elements to false, means no node has been visited
		for (int j = 0; j < visited.length ; j++) {
				visited[j] = false;
			}
		
		// for undirected graph, don't need to loop for every node
		DFS(0, matrix, visited);
		
		// check if there is any node not visited by DFS
		for (int i = 0; i < visited.length; i++) {
			if (!visited[i]) {
				return false;
			}
		}
		return true;
	}
	
	
	
	
	
	public int [][] createUndirectedGraph() {
		for (int i=0; i<n; i++) {
			for (int j=0; j<i; j++) {
				if (Choice.make(new double[] {p, 1-p}) == 0) {
					graphMatrix[i][j]=1;
					graphMatrix[j][i] =1;
				}
			}
		}
		// check if the graph is connected
		boolean isConnected = isConnectedUndirectedVer(graphMatrix);
		
		return graphMatrix;
	}
	public int [][] createDirectedGraph() {
		for (int i=0; i<n; i++)
			for (int j=0; j<n; j++)
				if (Choice.make(new double[] {p, 1-p}) == 0) 
					graphMatrix[i][j]=1;		
		
		// check if the graph is connected
		boolean isConnected = isConnectedDirectedVer(graphMatrix);
		
		return graphMatrix;
	}
	
	public int [] [] getMatrix (RandomGraph rg) {
		return rg.graphMatrix;
	}
}
