#include <iostream>
#include <algorithm>
using namespace std;

void f(int l, int r, int a[], int n) {
    if (l >= r) 
        return;
    swap(a[l], a[r]);
    f(l + 1, r - 1, a, n);
}

int main() {
    int n;
    cin >> n;
    int a[n];
    for(int i=0; i<n; i++)
        cin >> a[i];
    
    f(0, n - 1, a, n);

    for(int i=0; i<n; i++)
        cout << a[i] << " ";
    cout << endl;

    return 0;
}