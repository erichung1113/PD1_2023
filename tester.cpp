//g++ tester.cpp -o tester
#include <bits/stdc++.h>
using namespace std;
#define int long long

signed main(signed argc, char *argv[]){
    ifstream userans(argv[2]);
    ifstream answer(argv[3]);

    if(argv[1][0] == 'A'){
        vector<string> ans,uans;
        string line;
        while(getline(answer,line)) ans.push_back(line);
        while(getline(userans,line)) uans.push_back(line);
        return (ans == uans);
    }else{
        double ans, uans;
        answer >> ans;
        userans >> uans;
        if(abs(ans-uans)<=1e-12) return 1;
        else return 0;
    }
}
