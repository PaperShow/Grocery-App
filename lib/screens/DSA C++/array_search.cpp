#include<iostream>
using namespace std;

int search(int arr[],int n,int x){
    for (int i = 0; i < n; i++)
    {
        if (arr[i]==x)
        {
            return i;
        }      
    }
    return -1; 
}

int insert(int arr[],int n,int pos,int num,int cap){
    if(n == cap)
        return n;
    int index = pos-1;
    for (int i = n-1; i >= index; i--)
        arr[i+1] = arr[i];
    
    arr[index] = num;
    return (n+1);
    
}

int deleteArray(int arr[],int x, int n){
    int i;
    for ( i = 0; i < n; i++)
        if(arr[i] == x)
            break;
    if(i==n)
        return n;
    for (int j = i; j<n-1;j++)        
        arr[j] = arr[j+1];
    return (n-1);
}

int largest(int arr[],int n){
    int res = 0;
    for(int i=1; i<n; i++)
        if(arr[i] > arr[res])
            res = i;
    return res;
}

int secondLargest(int arr[],int n){
    int res = -1,lar = 0;

    for (int i = 1; i < n; i++)
    {
        if(arr[i]>arr[lar]){
            res = lar;
            lar = i;
        } else if(arr[i] != arr[lar]){
            if(res == -1 || arr[i]>arr[res])
                res = i;
        }
    }
    return res;
}

int removeDuplicates(int arr[], int n)
{
    if (n==0 || n==1)
        return n;
 
    // To store index of next unique element
    int j = 0;
 
    for (int i=0; i < n-1; i++)
        if (arr[i] != arr[i+1])
            arr[j++] = arr[i];
 
    arr[j++] = arr[n-1];
 
    return j;
}

int main(){
    // int arr[]={5,6,7,8,6};

    // -------insert------------------
    // int n = insert(arr,5,3,65,10);
    // cout<<n<<endl;;  
    // for (int i = 0; i<n; i++)
    //     cout<<arr[i]<<endl;
    
    // -------delete array--------------
    // int n = deleteArray(arr,7,5);
    // cout<<n<<endl;
    // for (int i = 0; i<n; i++)
    //     cout<<arr[i]<<endl;

    // --------Largest number ---------------
    // int arr[] = {5,20,9,10,8};
    // cout<<largest(arr,5);

    // --------Second Largest number ---------------
    // int arr[]= {5,20,9,10,8};
    // cout<<secondLargest(arr,5);
    // return 0;

    int arr[]= {5,8,8,9,9,13,13};
    int n = sizeof(arr) / sizeof(arr[0]);
    cout<<"Given Array : "<<endl;
    for(int i =0;i<n;i++){
        cout<<arr[i]<<" ";
    }
    cout<<endl;
    n = removeDuplicates(arr,n);
    
    cout<<"Array items after removing duplicate items"<<endl;
    for(int i =0;i<n;i++){
        cout<<arr[i]<<" ";
    }
    return 0;
}