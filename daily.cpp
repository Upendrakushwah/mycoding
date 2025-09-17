#include <iostream>
using namespace std;

void fun1(int n)
{
    if (n == 0)
        return;                     // base condition
    cout << "BAT" << endl;           // print "BAT"
    fun1(n - 1);                     // recursive call
}

int main()
{
    int n;
    cin >> n;                        // take input from user
    fun1(n);                         // call function with user input
    return 0;
}
