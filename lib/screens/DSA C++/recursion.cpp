#include<iostream>
#include<cstring>

using namespace std;

// nth fibonacci number
int fib(int n){
    if(n<=1) return n;
    return fib(n-1) + fib(n-2);
}

// print n to 1
void func1(int n){
    if(n<1) return;
    cout<<n;
    func1(n-1);
}
// print 1 to n -- tail recursive -- more efficient
void func2(int n, int k =1){
    if(n<1) return;
    cout<<k;
    func2(n-1,k+1);
}

// factorial -- tail recursive
int fact(int n,int val =1){
    if(n==0) return val;
    return fact(n-1, n*val);
}

bool isPal(char str[], int s, int e){
    if(s==e) return true;
    if(s>e) return true;
    if(str[s] != str[e]) return false;
    return isPal(str,s+1,e-1);
}

// sum of digits in number
int sum(int n){
    if(n<10) return n;
    return sum(n/10) + n%10;
}
int max(int n,int a, int b, int c){
    int f = n/a;
    if(f==0) return -1;
    int s = n/b;
    if(s==0) return -1;
    int t = n/c;
    if(t==0) return -1;
    if(f>t){
        if(f>s) return f;
        else return s;
    } else return t;
}
int main(){
    
    // cout<< fib(4);
    // cout<<fact(4);

    // char str[] = "aaba";
    // if(isPal(str,0,strlen(str)-1)) cout<<"yes";    // strlen is in #include<cstring> or directly put no of letters
    // else cout<<"no";
    
    // cout<<sum(345);

    cout<<max(5,4,2,6);
    
    

    return 0;
}