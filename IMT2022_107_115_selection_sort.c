// The C equivalent of the assembly code

#include <stdio.h>
#include <limits.h>

void mySort(int n, int *inputAddress, int *outputAddress, int toSort[]);

void mySort(int n, int *inputAddress, int *outputAddress, int toSort[]){
    //iterative implementation of the mySort function
    for (int j = 0; j < n; j++){
        int minimum = toSort[j];  int minIndex = j;
        for (int i = j+1; i < n; i++){
            if (toSort[i] < minimum)    
            {
                minimum = toSort[i];
                minIndex=i;
            }
        }
        int temp = toSort[j];   toSort[j] = minimum;    toSort[minIndex] = temp;
    }
}


int main(){
    int n;  int *inputAddress, *outputAddress;  int toSort[n];
    scanf("%d", &n);    
    for (int i = 0; i < n; i++) scanf("%d", &toSort[i]);
    mySort(n, inputAddress, outputAddress, toSort);
    for (int i = 0; i < n; i++){
        printf("%d ", toSort[i]);
    }

    return 0;
}