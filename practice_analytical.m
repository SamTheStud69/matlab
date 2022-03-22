clc 
clear all

A=[2 4 1 0; 3 5 0 1];
B=[8;15];
C=[3,2];
[m,n]=size(A);
solutions=[];
if n>m
    ncm=nchoosek(n,m);
    pair=nchoosek(1:n,m);

    for i=1:ncm
        y=zeros(n,1);
        X=A(:,pair(i,:))\B;
        y(pair(i,:))=X;

        if y>=0 & y~=inf
            solutions=[solutions y];
        end
    end

    res=C*solutions(1:size(C,2),:)
    optVal=max(res)
    a=find(optVal);
    optSol=solutions(:,a)
else
    print('Not a feasible solution')
end