#include <iostream>
using namespace std;

void f(int i){
    if (i<1)
       return ;
     cout<< i << " " ;
     f(i-1);
       }
int main(){
    int n;
    cin>> n ;
    f(n);
}