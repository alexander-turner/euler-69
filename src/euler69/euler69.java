package euler69;

import java.util.*;

class Ideone{

    static int length = (int) 1e6;
    static double[] totients = new double[length+1];
    static boolean[] composite = new boolean[length+1]; // sieve
    static List<List<Integer>> primeFactors = new ArrayList<List<Integer>>(length+1);
    
    public static void main(String[] args){
        fillSieve();
        
        int maxN = 0;
        double max = 0, temp = 0;
    
        for(int i=2; i<=length; i++){
            temp = i/calculateTotient(i);
            if(temp > max){
                max = temp;
                maxN = i;
            }
        }

        System.out.println("The maximum totient(n) (for 2 <= n <= " + length + ") is "+ maxN);
    }
    
    // Fills the sieve (composite) and generates prime factors up to length
    static void fillSieve(){
        for(int i=0; i<=length; i++){
        	totients[i] = 0;
            primeFactors.add(i, new ArrayList<Integer>()); // intialize lists
        }
        int limit = length/2;
    
        for(int i=2; i<=limit; i++)
            if(!composite[i])
                for(int j=2*i; j<=length; j+=i){
                    composite[j] = true; // mark as non-prime
                    primeFactors.get(j).add(i); // add the factor
                }
    }
    
    /*
    If we track all distinct prime factors for a number 
     (generating with sieve - add to stack at correct spot in array)
    We can calculate each totient using 
     totient(n) = n*powerseries(prime factors p of n): 1-1/p
    */ 
    static double calculateTotient(int n){
        if(totients[n] != 0) {
            //do nothing, already calculated
        } else if(!composite[n]){
            totients[n] = n-1;
        } else {
            double product = n;
            for(Integer prime : primeFactors.get(n))
                product *= 1 - ((double) 1/prime);
            
            totients[n] = product;
        }
    
        return totients[n];
    }
}
