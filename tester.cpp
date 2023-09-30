//g++ tester.cpp -o tester
#include <bits/stdc++.h>
using namespace std;
#define int long long

signed main(signed argc, char *argv[]){
    ifstream result(argv[2]);
    ifstream answer(argv[3]);

    vector<string> ans,res;
    string line;
    while(getline(answer,line)) if(line != "") ans.push_back(line);
    while(getline(result,line)) if(line != "") res.push_back(line);
    
    if(argv[1][0] == 'A'){
        if(res.size() != 1) return 0;
        int a,b,d,e;
        char c;
        stringstream resultss(res[0]);
        stringstream answerss(ans[0]);
        resultss >> a >> c >> b;
        answerss >> d >> c >> e;
        int g1=gcd(a,b);
        int g2=gcd(d,e);
        if(a/g1==d/g2 && b/g1==e/g2) return 1;
        else return 0;
    }else{
        return (ans == res);
    }
}
