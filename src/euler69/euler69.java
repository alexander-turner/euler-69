package euler69;

import java.util.*;
import java.lang.Math;

class Ideone{

    static int length = 1000;
    static int[] totients = new int[length+1];
    static List<List<Integer>> primeFactors = new ArrayList<List<Integer>>(length+1);
    
    static boolean[] composite = new boolean[length+1]; // sieve
    
    public static void main(String[] args){
        fillSieve();
        
        for(Integer prime : primeFactors.get(30))
        	System.out.println(prime);
        System.out.println(calculateTotient(30));
        int max = 0, maxN = 0, temp;
    
        /*for(int i=2; i<=length; i++){
            temp = calculateTotient(i);
            if(temp > max){
                max = temp;
                maxN = i;
            }
        }*/

        System.out.println("The maximum totient(n) (for 2 <= n <= " + length + ") is "+ maxN);
    }
    
    // Fills the sieve (composite) and generates prime factors up to length
    static void fillSieve(){
        for(int i=0; i<=length; i++)
            primeFactors.add(i, new ArrayList<Integer>()); // intialize lists

        int limit = (int) Math.sqrt(length);
    
        for(int i=2; i<limit; i++)
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
    static int calculateTotient(int n){
        if(totients[n] != 0) {
            //do nothing, already calculated
        } else if(!composite[n]){
            totients[n] = n-1;
        } else {
            int product = n;
            for(Integer prime : primeFactors.get(n)){
                product *= (1 - 1/prime);
                System.out.println(product);
            }
            
            totients[n] = product;
        }
    
        return totients[n];
    }
}
