#include<iostream>
using namespace std;

int smallest(int arr[],int n){
    int res = 0;
    for (int i = 1; i < n; i++)
    {
        if(arr[i]<arr[res]){
            res = i;
        }
            
    }
    return res;
}
int mergeTwoUnsortedArray(int arr1[],int arr2[],int n,int m,int arr3[]){
    for (int i = 0; i < n; i++)
    {
        arr3[i] = arr1[i];
    }
    int j = 0;
    for (int i = n; i < n+m; i++)
    {
        arr3[i] = arr2[j];
        j++;
    }
    
}

int main(){

    // int x, y ,s=0;
    // cin>>x>>y;
    // int *arr[x];
    // while (x--)
    // {   
    //     int n ;
    //     cin>>n;
    //     arr[s] = new int[n];
    //     for (int i = 0; i < n; i++)
    //     {
    //         cin>>arr[s][i];
    //     }       
    //     s++;
    // }
    // while (y--)
    // {
    //     int a,b;
    //     cin>>a>>b;
    //     cout<<arr[a][b]<<endl;
    // }

    int arr1[] = {64,10,5,6,10};
    int arr2[] = {6,12,15,3,1};
    int arr[10];
    mergeTwoUnsortedArray(arr1,arr2,5,5,arr);
    for(int x:arr){
        cout<<x<<" ";
    }
    


    
    return 0;
}




// void merge(int *,int, int , int );
// void merge_sort(int *arr, int low, int high)
// {
//     int mid;
//     if (low < high){
//         //divide the array at mid and sort independently using merge sort
//         mid=(low+high)/2;
//         merge_sort(arr,low,mid);
//         merge_sort(arr,mid+1,high);
//         //merge or conquer sorted arrays
//         merge(arr,low,high,mid);
//     }
// }
// // Merge sort 
// void merge(int *arr, int low, int high, int mid)
// {
//     int i, j, k, c[50];
//     i = low;
//     k = low;
//     j = mid + 1;
//     while (i <= mid && j <= high) {
//         if (arr[i] < arr[j]) {
//             c[k] = arr[i];
//             k++;
//             i++;
//         }
//         else  {
//             c[k] = arr[j];
//             k++;
//             j++;
//         }
//     }
//     while (i <= mid) {
//         c[k] = arr[i];
//         k++;
//         i++;
//     }
//     while (j <= high) {
//         c[k] = arr[j];
//         k++;
//         j++;
//     }
//     for (i = low; i < k; i++)  {
//         arr[i] = c[i];
//     }
// }
// // read input array and call mergesort
// int main()
// {
//     int myarray[30], num;
//     cout<<"Enter number of elements to be sorted:";
//     cin>>num;
//     cout<<"Enter "<<num<<" elements to be sorted:"<<endl;
//     for (int i = 0; i < num; i++) { cin>>myarray[i];
//     }
//     merge_sort(myarray, 0, num-1);
//     cout<<"Sorted array\n";
//     for (int i = 0; i < num; i++)
//     {
//         cout<<myarray[i]<<"\t";
//     }
// }