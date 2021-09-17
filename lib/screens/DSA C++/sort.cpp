#include<iostream>
#include<algorithm>

using namespace std;

void bubbleSort(int arr[],int n){
    for (int i = 0; i < n-1; i++)
        for (int j = 0; j < n-1; j++)
            if(arr[j]>arr[j+1])
                swap(arr[j],arr[j+1]); 
}

void selecSort(int arr[],int n){
    for (int i = 0; i < n-1; i++)
    {
        int min_ind = i;
        for (int j = i+1; j < n; j++) 
            if(arr[j]<arr[min_ind])
                min_ind = j;
        swap(arr[min_ind],arr[i]);      
    }
}

void insertionSort(int arr[],int n){
    for (int i = 1; i < n; i++)
    {
        int key = arr[i];
        int j = i-1;
        while(j>=0 && arr[j]>key){
            arr[j+1] = arr[j];
            j--;
        }
        arr[j+1] = key;
    }
    
}

void mergeTwoSorted(int a[],int b[],int m,int n){
    int i=0,j=0;
    while(i<m && j<n){
        if(a[i]<b[j]) cout<<a[i++]<<" ";
        else cout<<b[j++]<<" ";
    }
    while(i<m)  cout<<a[i++]<<" ";
    while(j<n)  cout<<b[j++]<<" ";
}
void mergeFun(int a[],int l,int m,int h){
    int i=0,j=m+1;
    while(i<m+1 && j<h+1){
        if(a[i]<a[j]) cout<<a[i++]<<" ";
        else cout<<a[j++]<<" ";
    }
    while(i<m+1) cout<<a[i++]<<" ";
    while(j<h+1) cout<<a[j++]<<" ";
}

void merge2(int a[],int l,int m,int r){      // not working well -:(
    int n1 = m-l+1 , n2 = r-m;
    int left[n1],right[n2];
    for(int i=0;i<n1;i++) left[i]=a[l+i];
    for(int j=0;j<n2;j++) right[j]=a[m+1+j];

    int i=0,j=0,k=l;
    while(i<n1 && j<n2){
        if(left[i]<=right[i]) a[k++]=left[i++];
        else a[k++]=right[j++];
    }
    while(i<n1) a[k++]=left[i++];
    while(j<n2) a[k++]=right[j++];
}

void merge(int arr[],int l,int m,int r){
    int i,j,k;
    // int n = r-l+1;  // not working when dynamic
    // int *c = new int[r-l+1];
    i = l;    
    j = m+1;
    k=l;
    int c[50];
    
    while(i<=m && j<=r) {
        if(arr[i]<arr[j]) c[k++] = arr[i++];
        else c[k++] = arr[j++];
    }
    while(i<=m) c[k++] = arr[i++];
    while(j<=r) c[k++] = arr[j++];
    for(int i=l;i<k;i++) arr[i] = c[i];
}

void mergeSort(int arr[],int l,int r){  
    if(l<r){
        int m = l+(r-l)/2;
        mergeSort(arr,l,m);
        mergeSort(arr,m+1,r);
        merge(arr,l,m,r);
    } 
}

// partition methods for quick sort

void partition(int arr[],int l,int h,int p){
    int temp[h-l+1] , index = 0;
    for(int i = l;i<=h;i++){
        if(arr[i]<= arr[p]){
            temp[index] = arr[i]; 
            index++;
        }
    }    
    for(int i = l;i<=h;i++){
        if(arr[i]> arr[p]){
            temp[index] = arr[i]; 
            index++;
        }
    }
    for(int i = l;i<=h;i++)
        arr[i] = temp[i-l];
}

int lPartition(int arr[],int l,int h){
    int pivot  = arr[h];
    int i= l-1;
    
    for(int j = l;j <= h-1;j++){
        if(arr[j]<arr[pivot]){
            i++;
            swap(arr[i],arr[j]);
        }
    }
    swap(arr[i+1], arr[h]);
    return (i+1);
}

int main(){
    // int arr[] = {10,20,5,7};
    // sort(arr,arr+4);

    // for(int x:arr)
    //     cout<<x<<" ";
    // sort(arr,arr+4);
    // cout<<endl;
    // for(int x:arr)
    //     cout<<x<<" ";

    // int arr[] = {10,20,5,7,1};
    // selecSort(arr,5);
    // for(int x:arr)
    //     cout<<x<<" ";
    // return 0;

    // int a[] = {10,15,20,40};
    // int b[] = {8,11,15,22,25};
    // mergeTwoSorted(a,b,4,5);
    int arr[] = {10,20,5,7,1};
    // insertionSort(arr,5);

    // int a[] = {10,15,20,40,8,11,15,22,25};
    // // mergeFun(a,0,3,8);

    // int b[] = {10,5,30,15,7};
    // mergeSort(a,0,8);

    // partition(arr,0,4,2);
    lPartition(arr,0,4);
    
    for(int x:arr){
        cout<<x<<" ";
    }
}